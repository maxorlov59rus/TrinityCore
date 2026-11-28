<#
.SYNOPSIS
Creates/links the Projects v2 board for this repository and writes .git/project-sync.json.

.DESCRIPTION
Requires a GitHub token with the `project` scope. The token is taken from
$env:GITHUB_PROJECT_TOKEN, otherwise from the Git Credential Manager entry for github.com.

Board: "new-content"
Sections (single-select field "Раздел"):
  База, Ядро, Навыки, Документация и Прочее

After setup, install .git/hooks/post-commit (see tools/install-project-hook.ps1) and
call tools/sync-commit-to-project.ps1 for every new commit.
#>
[CmdletBinding()]
param(
    [int]$Backfill = 12,
    [string]$Title = 'new-content'
)

$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Owner = 'maxorlov59rus'
$RepoName = 'TrinityCore'
$ConfigPath = Join-Path $RepoRoot '.git\project-sync.json'
$LogPath = Join-Path $RepoRoot '.git\project-sync-log.txt'

function Get-GitHubToken {
    if ($env:GITHUB_PROJECT_TOKEN) { return $env:GITHUB_PROJECT_TOKEN }

    Push-Location $RepoRoot
    try {
        $credentialInput = "protocol=https`nhost=github.com`n`n"
        $credentialOutput = $credentialInput | git credential fill 2>$null
    }
    finally { Pop-Location }

    $line = $credentialOutput | Where-Object { $_ -like 'password=*' } | Select-Object -First 1
    if (-not $line) {
        throw 'GitHub token not found. Set GITHUB_PROJECT_TOKEN or configure git credential helper.'
    }
    return $line.Substring(9)
}

$Token = Get-GitHubToken
$Headers = @{
    Authorization = "Bearer $Token"
    'User-Agent'  = 'TrinityCore-project-sync'
}

function Invoke-GraphQL {
    param([string]$Query, [hashtable]$Variables = @{})

    $body = @{ query = $Query; variables = $Variables } | ConvertTo-Json -Depth 14 -Compress
    $response = Invoke-RestMethod -Uri 'https://api.github.com/graphql' `
        -Method Post -Headers $Headers -ContentType 'application/json; charset=utf-8' -Body $body

    if ($response.errors) {
        $messages = $response.errors | ForEach-Object { $_.message }
        throw "GraphQL error: $($messages -join '; ')"
    }
    return $response.data
}

Write-Host '==> Looking up repository...'
$repoData = Invoke-GraphQL -Query 'query($owner:String!,$name:String!){ repository(owner:$owner,name:$name){ id owner{ id login } } }' `
    -Variables @{ owner = $Owner; name = $RepoName }
$repository = $repoData.repository
if (-not $repository) { throw "Repository $Owner/$RepoName not found or token cannot read it." }

Write-Host '==> Looking for existing project...'
$projectsData = Invoke-GraphQL -Query 'query { viewer { projectsV2(first:100) { nodes { id number title url } } } }'
$project = $projectsData.viewer.projectsV2.nodes | Where-Object { $_.title -eq $Title } | Select-Object -First 1

if (-not $project) {
    Write-Host '==> Creating project...'
    $created = Invoke-GraphQL -Query 'mutation($input:CreateProjectV2Input!){ createProjectV2(input:$input){ projectV2{ id number title url } } }' `
        -Variables @{ input = @{ ownerId = $repository.owner.id; repositoryId = $repository.id; title = $Title } }
    $project = $created.createProjectV2.projectV2
}
else {
    Write-Host "==> Reusing project #$($project.number): $($project.url)"
}

$ProjectId = $project.id

$readme = @"
# new-content

Проверенный Blizzlike-контент для TrinityCore `master`, клиент **12.1.5.70961**.

## Разделы

| Раздел | Что туда попадает |
|---|---|
| База | Чистые SQL/DB правки без C++-скриптов |
| Ядро | `src/server/game/**`, CMake, конфиги, регистрация скриптов |
| Навыки | Скрипты заклинаний/талантов/квестов/механик и связанные с ними SQL |
| Документация и Прочее | README, изображения, вспомогательные файлы |

Каждый новый коммит добавляется сюда локальным `post-commit` хуком как черновик issue
с ссылкой на коммит и полем **Раздел**.

Чат: https://lolka.gg/8snOouNIX
"@

Write-Host '==> Updating project description...'
Invoke-GraphQL -Query 'mutation($input:UpdateProjectV2Input!){ updateProjectV2(input:$input){ projectV2{ id url } } }' `
    -Variables @{ input = @{
        projectId       = $ProjectId
        shortDescription = 'Blizzlike-контент для TrinityCore 12.1.5.70961'
        readme          = $readme
    } } | Out-Null

Write-Host '==> Reading fields...'
$fieldsQuery = @'
query($id:ID!){
  node(id:$id){
    ... on ProjectV2 {
      fields(first:100){
        nodes{
          __typename
          ... on ProjectV2Field { id name dataType }
          ... on ProjectV2SingleSelectField { id name options { id name color } }
        }
      }
    }
  }
}
'@
$fieldData = Invoke-GraphQL -Query $fieldsQuery -Variables @{ id = $ProjectId }
$fields = @($fieldData.node.fields.nodes)

$sectionNames = @('База', 'Ядро', 'Навыки', 'Документация и Прочее')
$sectionColors = @{ 'База' = 'GREEN'; 'Ядро' = 'BLUE'; 'Навыки' = 'PURPLE'; 'Документация и Прочее' = 'YELLOW' }

$sectionField = $fields | Where-Object { $_.name -eq 'Раздел' -and $_.options } | Select-Object -First 1

if (-not $sectionField) {
    Write-Host '==> Creating field "Раздел"...'
    $options = foreach ($name in $sectionNames) {
        @{ name = $name; description = 'Категория коммита'; color = $sectionColors[$name] }
    }
    $createdField = Invoke-GraphQL -Query 'mutation($input:CreateProjectV2FieldInput!){ createProjectV2Field(input:$input){ projectV2Field{ ... on ProjectV2SingleSelectField { id name options{ id name } } } } }' `
        -Variables @{ input = @{
            projectId = $ProjectId
            name = 'Раздел'
            dataType = 'SINGLE_SELECT'
            singleSelectOptions = @($options)
        } }
    $sectionField = $createdField.createProjectV2Field.projectV2Field
}
else {
    $existing = @($sectionField.options | ForEach-Object { $_.name })
    $missing = @($sectionNames | Where-Object { $_ -notin $existing })
    if ($missing.Count -gt 0) {
        Write-Host "==> Adding missing options: $($missing -join ', ')"
        $allOptions = foreach ($opt in $sectionField.options) { @{ id = $opt.id; name = $opt.name; color = $opt.color } }
        foreach ($name in $missing) {
            $allOptions += @{ name = $name; description = 'Категория коммита'; color = $sectionColors[$name] }
        }
        $updatedField = Invoke-GraphQL -Query 'mutation($input:UpdateProjectV2FieldInput!){ updateProjectV2Field(input:$input){ projectV2Field{ ... on ProjectV2SingleSelectField { id options{ id name } } } } }' `
            -Variables @{ input = @{ fieldId = $sectionField.id; singleSelectOptions = @($allOptions) } }
        $sectionField = $updatedField.updateProjectV2Field.projectV2Field
    }
}

$optionIds = @{}
foreach ($opt in $sectionField.options) { $optionIds[$opt.name] = $opt.id }
foreach ($name in $sectionNames) {
    if (-not $optionIds.ContainsKey($name)) { throw "Option '$name' is missing in field 'Раздел'." }
}

function Ensure-TextField {
    param([string]$Name)
    $field = $fields | Where-Object { $_.name -eq $Name -and $_.dataType -eq 'TEXT' } | Select-Object -First 1
    if ($field) { return $field }
    Write-Host "==> Creating text field '$Name'..."
    $created = Invoke-GraphQL -Query 'mutation($input:CreateProjectV2FieldInput!){ createProjectV2Field(input:$input){ projectV2Field{ ... on ProjectV2Field { id name } } } }' `
        -Variables @{ input = @{ projectId = $ProjectId; name = $Name; dataType = 'TEXT' } }
    return $created.createProjectV2Field.projectV2Field
}

$commitField = Ensure-TextField -Name 'Commit'
$filesField = Ensure-TextField -Name 'Файлы'

$statusField = $fields | Where-Object { $_.name -eq 'Status' -and $_.options } | Select-Object -First 1
if (-not $statusField) { $statusField = $fields | Where-Object { $_.name -eq 'Статус' -and $_.options } | Select-Object -First 1 }
$doneOptionId = $null
if ($statusField) {
    $done = $statusField.options | Where-Object { $_.name -in @('Done', 'Готово') } | Select-Object -First 1
    if ($done) { $doneOptionId = $done.id }
}

$config = [ordered]@{
    owner           = $Owner
    repo            = $RepoName
    projectId       = $ProjectId
    projectNumber   = $project.number
    projectUrl      = $project.url
    sectionFieldId  = $sectionField.id
    sectionOptions  = $optionIds
    commitFieldId   = $commitField.id
    filesFieldId    = $filesField.id
    statusFieldId   = if ($statusField) { $statusField.id } else { $null }
    doneOptionId    = $doneOptionId
}
$config | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ConfigPath -Encoding UTF8

if (-not (Test-Path -LiteralPath $LogPath)) { New-Item -ItemType File -Path $LogPath | Out-Null }

Write-Host "==> Config written: $ConfigPath"
Write-Host "==> Project: $($project.url)"

if ($Backfill -gt 0) {
    Write-Host "==> Backfilling last $Backfill commits..."
    $commits = @(git -C $RepoRoot log -$Backfill --format='%H' | Where-Object { $_ })
    foreach ($sha in $commits) {
        & (Join-Path $PSScriptRoot 'sync-commit-to-project.ps1') -Commit $sha -ConfigPath $ConfigPath
        if ($LASTEXITCODE -eq 2) { throw 'Token/scope problem during backfill. See output above.' }
    }
}
