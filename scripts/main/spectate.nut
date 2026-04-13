/*

File: spectate.nut

Description: Spectating players.

*/


exitSpecKey <- BindKey(true, 0x08, 0, 0) // Backspace 

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower())
    {
        case "spec":
        {
            if(!player.IsSpawned || playerData[player.ID].adminLevel >= 1)
            {
                local targetplr = GetPlayer(text)
                if(targetplr)
                {
                    if(targetplr.ID != player.ID)
                    {
                        if(targetplr.IsSpawned)
                        {
                            MessagePlayer(COLOR_GREEN + "You've entered spectator mode.", player);
                            MessagePlayer(COLOR_GREEN + "Press backspace to exit from spectator mode.", player);
                            player.SpectateTarget = targetplr;
                        } else MessagePlayer(COLOR_RED + "Target player is not spawned!", player);
                    }
                    else MessagePlayer(COLOR_RED + "You can't spectate yourself!", player);
                }
                else MessagePlayer(COLOR_RED + "Target player not found!", player);
            }
            else MessagePlayer(COLOR_RED + "You can't use this command when spawned!", player);
            break;
        }
    }
}

function onKeyDown(player, key)
{
    if(key == exitSpecKey) {
        player.SpectateTarget = null;
    }
}