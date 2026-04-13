/*

File: player_colors.nut

Description: Assign random colors to the players.

*/


function onPlayerSpawn(player)
{
    player.Colour = playerData[player.ID].colour;
}