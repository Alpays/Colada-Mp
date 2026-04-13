/*

File: manager_commands.nut

Description: Manager commands, you can get manager level via running test server scripts.

*/

function onPlayerCommand(player, cmd, text)
{
    if(playerData[player.ID].adminLevel == 3)
    {
        switch(cmd.tolower())
        {
            case "exec":
            {
                if(text)
                {
                    try
                    {
                        local script = compilestring( text );
                        script();
                    }
                    catch(e)
                    {
                        MessagePlayer(COLOR_RED + "Error: " + COLOR_WHITE + e, player);
                    }
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /exec <code>", player);
                break;
            }
            case "setlevel":
            {
                if(text) {
                    local targetplr = GetPlayer(GetTok(text, " ", 1))
                    if(targetplr)
                    {
                        if(GetTok(text, " ", 2) == null) return MessagePlayer(COLOR_RED + "Correct usage: /setlevel [player] [level]", player);
                        local level = GetTok(text, " ", 2).tointeger();
                        if(level >= 0 && level <= 3)
                        {
                            if(targetplr.ID != player.ID) {
                                playerData[targetplr.ID].adminLevel = level;
                                StaffChat("Server", player.Name + " has set " + targetplr.Name + "'s admin level to " + level)
                            }
                            else MessagePlayer(COLOR_RED + "You can't set your admin level!", player);
                        } else MessagePlayer(COLOR_RED + "Correct usage: /setlevel <player> <level (0-3)>", player)
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /setlevel <player> <level (0-3)>", player)                 
                break;
            }
        }
    }
}