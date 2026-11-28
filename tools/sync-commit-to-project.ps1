<#
.SYNOPSIS
Adds one commit to the Projects v2 board as a draft issue with a "Раздел" value.

.DESCRIPTION
Called by .git/hooks/post-commit. Can also be called manually:
  powershell -File tools/sync-commit-to-project.ps1 -Commit HEAD

Uses .git/project-sync.json produced by setup-github-project.ps1.
Requires a GitHub token with the `project` scope.
#>
[CmdletBinding()]
param(
    [string]$Commit = 'HEAD',
    [string]$ConfigPath
)

$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $ConfigPath) { $ConfigPath = Join-Path $RepoRoot '.git\project-sync.json' }
$LogPath = Join-Path $RepoRoot '.git\project-sync-log.txt'
$LastLog = Join-Path $RepoRoot '.git\project-sync-last.log'

function Write-SyncLog {
    param([string]$Message)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $Message"
    Add-Content -LiteralPath $LastLog -Value $line -Encoding UTF8
}

function Get-GitHubToken {
    if ($env:GITHUB_PROJECT_TOKEN) { return $env:GITHUB_PROJECT_TOKEN }
    Push-Location $RepoRoot
    try {
        $credentialInput = "protocol=https`nhost=github.com`n`n"
        $credentialOutput = $credentialInput | git credential fill 2>$null
    }
    finally { Pop-Location }
    $line = $credentialOutput | Where-Object { $_ -like 'password=*' } | Select-Object -First 1
    if (-not $line) { return $null }
    return $line.Substring(9)
}

try {
    if (-not (Test-Path -LiteralPath $ConfigPath)) {
        throw "Project config not found: $ConfigPath. Run tools/setup-github-project.ps1 first."
    }
    $config = Get-Content -LiteralPath $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json

    $token = Get-GitHubToken
    if (-not $token) {
        Write-SyncLog 'ERROR: GitHub token not found.'
        Write-Error 'GitHub token not found. Set GITHUB_PROJECT_TOKEN or update git credential for github.com.'
        exit 2
    }

    $headers = @{
        Authorization = "Bearer $token"
        'User-Agent'  = 'TrinityCore-project-sync'
    }

    function Invoke-GraphQL {
        param([string]$Query, [hashtable]$Variables = @{})
        $body = @{ query = $Query; variables = $Variables } | ConvertTo-Json -Depth 14 -Compress
        $response = Invoke-RestMethod -Uri 'https://api.github.com/graphql' -Method Post `
            -Headers $headers -ContentType 'application/json; charset=utf-8' -Body $body
        if ($response.errors) {
            $messages = $response.errors | ForEach-Object { $_.message }
            throw "GraphQL error: $($messages -join '; ')"
        }
        return $response.data
    }

    $metaRaw = git -C $RepoRoot log -1 --format='%H%x1f%h%x1f%s%x1f%an%x1f%aI' $Commit
    if (-not $metaRaw) { throw "Commit not found: $Commit" }
    $meta = $metaRaw -split [char]0x1F
    $sha = $meta[0]
    $short = $meta[1]
    $subject = $meta[2]
    $author = $meta[3]
    $date = $meta[4]
    $files = @(git -C $RepoRoot show --pretty='' --name-only --format='' $sha | Where-Object { $_ })

    if (-not (Test-Path -LiteralPath $LogPath)) { New-Item -ItemType File -Path $LogPath | Out-Null }
    $synced = @(Get-Content -LiteralPath $LogPath -ErrorAction SilentlyContinue)
    if ($synced -contains $sha) {
        Write-SyncLog "SKIP already synced: $short"
        exit 0
    }

    # Classification priority: scripts/skills -> core -> database -> docs.
    $isSkill = $false
    $isCore = $false
    $isDb = $false
    foreach ($file in $files) {
        if ($file -match '(?i)^src/server/scripts/') { $isSkill = $true }
        if ($file -match '(?i)^sql/.*(?i)(spell|talent|proc|aura|prayer|wisdom|monkey|skill|class)') { $isSkill = $true }
        if ($file -match '(?i)^src/server/game/|^cmake/|^CMakeLists|^\.github/|^conf/|custom_script_loader|^tools/|\.cmd$') { $isCore = $true }
        if ($file -match '(?i)^sql/|\.sql$') { $isDb = $true }
    }

    if ($isSkill) { $section = 'Навыки' }
    elseif ($isCore) { $section = 'Ядро' }
    elseif ($isDb) { $section = 'База' }
    else { $section = 'Документация и Прочее' }

    $optionId = $config.sectionOptions.$section
    if (-not $optionId) { throw "No project option ID for section '$section'." }

    $url = "https://github.com/$($config.owner)/$($config.repo)/commit/$sha"
    $fileList = if ($files.Count -gt 0) { ($files | ForEach-Object { '- ' + $_ }) -join "`n" } else { '- (нет изменённых файлов)' }
    $body = @"
Коммит: [$short]($url)
Автор: $author
Дата: $date
Раздел: **$section**

Изменённые файлы:
$fileList

Классификация выполняется автоматически по путям файлов. См. `tools/sync-commit-to-project.ps1`.
"@

    $created = Invoke-GraphQL -Query 'mutation($input:AddProjectV2DraftIssueInput!){ addProjectV2DraftIssue(input:$input){ projectItem{ id } } }' `
        -Variables @{ input = @{
            projectId = $config.projectId
            title     = "$short · $subject"
            body      = $body
        } }
    $itemId = $created.addProjectV2DraftIssue.projectItem.id

    $updateMutation = 'mutation($input:UpdateProjectV2ItemFieldValueInput!){ updateProjectV2ItemFieldValue(input:$input){ projectV2Item{ id } } }'

    Invoke-GraphQL -Query $updateMutation -Variables @{ input = @{
        projectId = $config.projectId; itemId = $itemId; fieldId = $config.sectionFieldId
        value = @{ singleSelectOptionId = $optionId }
    } } | Out-Null

    Invoke-GraphQL -Query $updateMutation -Variables @{ input = @{
        projectId = $config.projectId; itemId = $itemId; fieldId = $config.commitFieldId
        value = @{ text = $sha }
    } } | Out-Null

    Invoke-GraphQL -Query $updateMutation -Variables @{ input = @{
        projectId = $config.projectId; itemId = $itemId; fieldId = $config.filesFieldId
        value = @{ text = ($files -join "`n") }
    } } | Out-Null

    if ($config.statusFieldId -and $config.doneOptionId) {
        Invoke-GraphQL -Query $updateMutation -Variables @{ input = @{
            projectId = $config.projectId; itemId = $itemId; fieldId = $config.statusFieldId
            value = @{ singleSelectOptionId = $config.doneOptionId }
        } } | Out-Null
    }

    Add-Content -LiteralPath $LogPath -Value $sha -Encoding UTF8
    Write-SyncLog "ADDED $short [$section] $($config.projectUrl)"
    Write-Host "Added $short to $section"
    exit 0
}
catch {
    $msg = $_.Exception.Message
    if ($msg -match 'INSUFFICIENT_SCOPES|project') {
        Write-SyncLog "ERROR scope/auth: $msg"
        Write-Error "GitHub token needs the `project` scope. Current token is missing it."
        exit 2
    }
    Write-SyncLog "ERROR: $msg"
    Write-Error $msg
    exit 1
}
