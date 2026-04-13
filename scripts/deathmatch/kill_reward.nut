/*

File: kill_reward.nut

Description: Bonus money for each kill.

*/

local killReward = 750;
local deathMoney = 250;

function onPlayerKill(killer, player, reason, bodypart) {
    killer.IncCash(killReward);
    killer.IncHealth(35);
    player.DecCash(deathMoney);
}