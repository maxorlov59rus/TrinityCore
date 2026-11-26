-- Quest 40254 "Forged in Fire" is a hidden tracking quest: it is granted
-- silently by the Demon Hunter artifact campaign to award the off-spec unlock
-- spell. Without QUEST_FLAGS_TRACKING_EVENT (0x400) it shows up as a duplicate
-- visible quest log entry. Ported from BFA-HavenCore 2026_07_10_00.sql.

UPDATE `quest_template` SET `Flags` = `Flags` | 0x400 WHERE `ID` = 40254;
