/*

File: player_scores.nut

Description: Increases player's score by one for each kill.

*/

function onPlayerKill(killer, player, r, b)
{
    killer.Score++;
}