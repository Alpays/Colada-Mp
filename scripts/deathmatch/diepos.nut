/*

File: diepos.nut

Description: Allows players to spawn where they die for a more quick paced deathmatch.

*/

function onPlayerKill(killer, player, r, b)
{
    playerData[player.ID].diePos = player.Pos;
}

function onPlayerSpawn(player)
{
    if(playerData[player.ID].spawnOnDeath && playerData[player.ID].diePos != null)
    {
        if(GetPlayers() >= 6)
        {
            player.Pos = Vector(playerData[player.ID].diePos.x + random(-75, 75), playerData[player.ID].diePos.y + random(-75, 75), -99999);
        }
        else player.Pos = playerData[player.ID].diePos;
    }
}

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower())
    {
        case "diepos":
        {
            if(playerData[player.ID].spawnOnDeath)
            {
                playerData[player.ID].spawnOnDeath = false;
                MessagePlayer(COLOR_BLUE + "Diepos disabled. You will not spawn where you get killed.", player);
            }
            else {
                playerData[player.ID].spawnOnDeath = true;
                MessagePlayer(COLOR_BLUE + "Diepos enabled. You will spawn around where you get killed.", player);
                MessagePlayer(COLOR_BLUE + "Warning: If your diepos is enabled when player count is higher than 5, you get teleported AROUND where you get killed, not in the exact location.", player);
            }
        }
    }
}

function onPlayerDeath(player, reason)
{
    playerData[player.ID].diePos = null;
}