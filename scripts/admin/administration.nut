/*

File: administration.nut

Description: Basic commands to administrate the server.

*/


function onPlayerCommand(player, cmd, text)
{
    local adminlevel = playerData[player.ID].adminLevel;
    if(adminlevel >= 2) 
    {
        switch(cmd.tolower())
        {
            case "getip":
            {
                if(text)
                {
                    local targetplr = GetPlayer(text);
                    if(targetplr)
                    {
                        MessagePlayer(COLOR_PINK + targetplr.Name + "'s" COLOR_WHITE + " IP Address: " + COLOR_PINK + targetplr.IP, player);
                    }
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /getip <target player>", player);
                break;
            }
            case "togglecrouch":
            {
                if(GetCrouchEnabled())
                {
                    SetCrouchEnabled(false);
                    Message(COLOR_BLUE + "Admin: " + COLOR_WHITE + player.Name + COLOR_BLUE + " disabled crouching!");
                }
                else
                {
                    SetCrouchEnabled(true);
                    Message(COLOR_BLUE + "Admin: " + COLOR_WHITE + player.Name + COLOR_BLUE + " enabled crouching!");
                }
                break;
            }
            case "goto":
            {
                if(text)
                {
                    local targetplr = GetPlayer(text);
                    if(targetplr)
                    {
                        if(player.IsSpawned)
                        {
                            if(targetplr.IsSpawned)
                            {
                                if(player.ID != targetplr.ID)
                                {
                                    player.Pos = targetplr.Pos;
                                    player.Pos.x += 0.75;
                                    player.Pos.y += 0.75;
                                    StaffChat("Server", player.Name + " teleported to " + targetplr.Name);
                                }
                                else MessagePlayer(COLOR_RED + "You can't teleport to yourself!", player);
                            }
                            else MessagePlayer(COLOR_RED + "Target player is not spawned!", player);
                        }
                        else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
                    }
                    else MessagePlayer(COLOR_RED + "Target player not found!", player);
                } else MessagePlayer(COLOR_RED + "Correct usage: /goto <player>", player);
                break;
            }
            case "bring":
            {
                if(text)
                {
                    local targetplr = GetPlayer(text);
                    if(targetplr)
                    {
                        if(player.IsSpawned)
                        {
                            if(targetplr.IsSpawned)
                            {
                                if(player.ID != targetplr.ID)
                                {
                                    targetplr.Pos = player.Pos;
                                    targetplr.Pos.x += 0.75;
                                    targetplr.Pos.y += 0.75;
                                    StaffChat("Server", player.Name + " brought " + targetplr.Name);
                                }
                                else MessagePlayer(COLOR_RED + "You can't bring to yourself!", player);
                            }
                            else MessagePlayer(COLOR_RED + "Target player is not spawned!", player);
                        }
                        else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
                    }
                    else MessagePlayer(COLOR_RED + "Target player not found!", player);
                } else MessagePlayer(COLOR_RED + "Correct usage: /bring <player>", player);
                break;
            }
            case "bringall":
            {
                for(local i = 0; i < GetMaxPlayers(); ++i) {
                    if(GetPlayer(i)) GetPlayer(i).Pos = player.Pos;
                }
                StaffChat("Server", player.Name + " brought every player");
                break;
            }
            case "reward":
            {
                if(text) {
                    if(NumTok(text, " ") == 2 && IsNum(GetTok(text, " ", 2)))
                    {
                        local plr = GetPlayer(GetTok(text, " ", 1));
                        local amount = GetTok(text, " ", 2).tointeger();
                        if(plr)
                        {
                            plr.Cash += amount 
                            Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " has rewarded " + COLOR_WHITE + plr.Name + COLOR_BLUE + " amount: [" + COLOR_WHITE + amount.tostring() + "$" + COLOR_BLUE + "]");
                        }
                    } else MessagePlayer(COLOR_RED + "Correct usage: /reward <player> <amount>", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /reward <player> <amount>", player)
                break;
            }
            case "givewep":
            {
                if(adminlevel >= 2) 
                {
                    if(text) {
                        if(NumTok(text, " ") == 3 && IsNum(GetTok(text, " ", 2)) && IsNum(GetTok(text, " ", 3))) {
                            local targetplr = GetPlayer(GetTok(text, " ", 1))
                            local wep = GetTok(text, " ", 2).tointeger();
                            local ammo = GetTok(text, " ", 3).tointeger();
                            if(targetplr)
                            {
                                targetplr.SetWeapon(wep, ammo)
                                StaffChat("Server", player.Name + " is giving " + GetWeaponName(wep) + " with " + ammo + " ammo to " + targetplr.Name)
                            } else MessagePlayer(COLOR_RED + "Player not found!", player)
                        } else MessagePlayer(COLOR_RED + "Correct usage: /givewep <player> <weapon id> <ammo>", player)
                    } else MessagePlayer(COLOR_RED + "Correct usage: /givewep <player> <weapon id> <ammo>", player)
                } 
                break;
            }
            case "givewepall":
            {
                if(adminlevel >= 2) 
                {
                    if(text) {
                        if(NumTok(text, " ") == 2)
                        {
                            if(IsNum(GetTok(text, " ", 1)) && IsNum(GetTok(text, " ", 2)))
                            {
                                local wep = GetTok(text, " ", 1).tointeger();
                                local ammo = GetTok(text, " ", 2).tointeger();
                                for(local i = 0; i < GetMaxPlayers(); ++i)
                                {
                                    if(GetPlayer(i)) {
                                        GetPlayer(i).SetWeapon(wep, ammo);
                                    }
                                }
                                Message(COLOR_PINK + "Admin " + COLOR_WHITE + player.Name + COLOR_PINK + " is giving " + COLOR_WHITE + GetWeaponName(wep) + COLOR_PINK + " with " + COLOR_WHITE + ammo + COLOR_PINK + " ammo to everyone!");
                            }
                            else MessagePlayer(COLOR_RED + "Correct usage: /givewepall <weapon id> <ammo>", player);
                        }
                        else MessagePlayer(COLOR_RED + "Correct usage: /givewepall <weapon id> <ammo>", player)
                    } else MessagePlayer(COLOR_RED + "Correct usage: /givewepall <weapon id> <ammo>", player)
                } 
                break;
            }
            case "s":
            case "pos":
            case "mypos":
            {
                MessagePlayer(COLOR_BLUE + "Your Position: X: " + player.Pos.x + " Y: " + player.Pos.y + " Z: " + player.Pos.z + " Angle: " + player.Angle, player);
                break;
            }
            case "v":
            case "tempveh":
            {
                if(text && IsNum(text))
                { 
                    local vehicle = CreateVehicle( text.tointeger(), player.Pos, 1, 7, 1);
                }
                else 
                {
                    MessagePlayer(COLOR_RED + "Correct usage: /v [vehicle id]");
                }
                break;
            }
        }
    }
}