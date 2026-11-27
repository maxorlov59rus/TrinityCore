-- Katie Stokx <Horse Breeder> showed the wrong icon and did not open gossip (issue #30181).
UPDATE `creature_template` SET `npcflag`=128, `VerifiedBuild`=69497 WHERE `entry`=43694;
