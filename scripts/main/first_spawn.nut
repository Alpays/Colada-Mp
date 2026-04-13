/*

File: first_spawn.nut

Description: Checks if player is spawned for the first time in the session.

*/


function onPlayerSpawn(player)
{
    if(playerData[player.ID].firstSpawn)
    {
        playerData[player.ID].firstSpawn = false;
        player.SpawnSound();
        // PlaySound(player.UniqueWorld, 50001, player.Pos);
    }
}