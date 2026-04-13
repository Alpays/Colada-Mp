/*

File: ffa.nut

Description: Removes teams.

*/

function onPlayerSpawn(player) {
    player.Team = player.ID;
}