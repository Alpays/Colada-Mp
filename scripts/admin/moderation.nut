/*

File: moderation.nut

Description: Basic commands to moderate the server.

*/

function onPlayerCommand(player, cmd, text)
{
    local adminlevel = playerData[player.ID].adminLevel;
    if(adminlevel >= 1)
    {
        switch(cmd.tolower())
        {
            case "sc":
            case "ac":
            {
                if(text)
                {
                    StaffChat(player.Name, text);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /sc <text>", player);
                break;
            }
            case "freecam":
            case "fc":
            {
                if(Freeview.players[player.ID].isOnView)
                {
                    Freeview.exitView(player);
                    MessagePlayer(COLOR_GREEN + "Exiting the freecam mode...", player);
                }
                else 
                {
                    Freeview.enterView(player);
                    MessagePlayer(COLOR_GREEN + "Entering the freecam mode...", player);
                }
                break;
            }
            case "weather":
            case "setweather": 
            {
                if(text && IsNum(text))
                {
                    local weather = text.tointeger();
                    if(weather >= 0 && weather <= 6) // IDs above 6 are corrupt weathers
                    {
                        if(snow.snowing && weather != 7) // Changing weather from Snow. 
                        {
                            for(local i = 0; i < GetMaxPlayers(); ++i)
                            {
                                if(FindPlayer(i))
                                {
                                    local str = Stream();
                                    str.StartWrite();
                                    str.WriteByte(STREAM_EXITSNOW);
                                    str.SendStream(FindPlayer(i));
                                    snow.snowing = false;
                                }
                            }
                        }
                        SetWeather(weather);
                        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " has set weather to [" + COLOR_WHITE + GetWeatherName(weather) + COLOR_BLUE + "]");
                    }
                    else if(weather == 7) {
                        SetWeather(3);
                        for(local i = 0; i < GetMaxPlayers(); ++i)
                        {
                            if(FindPlayer(i))
                            {
                                local str = Stream();
                                str.StartWrite();
                                str.WriteByte(STREAM_STARTSNOW);
                                str.SendStream(FindPlayer(i));
                                snow.snowing = true;
                            }
                        }
                        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " has set weather to [" + COLOR_WHITE + GetWeatherName(weather) + COLOR_BLUE + "]");
                    }
                    else MessagePlayer(COLOR_RED + "Invalid weather id.", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /setweather <weather id>", player);
                break;
            }
            case "time":
            case "settime":
            {
                if(text && IsNum(GetTok(text, " ", 1)))
                {
                    local hour = GetTok(text, " ", 1).tointeger();
                    if(NumTok(text, " ") != 2) 
                    {
                        SetHour(hour);
                        SetMinute(0);
                        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " set time to " + COLOR_WHITE + hour + ":00");
                    }
                    else if(IsNum(GetTok(text, " ", 2))) {
                        local minute = GetTok(text, " ", 2).tointeger();
                        SetHour(hour);
                        SetMinute(minute);
                        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " set time to " + COLOR_WHITE + hour + ":" + minute);
                    }
                    else MessagePlayer(COLOR_RED + "Correct usage: /settime <hour> [<minute>]", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /settime <hour> [<minute>]", player);
                break;
            }

            case "kick":
            {
                if(text && NumTok(text, " ") >= 2) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        targetplr.Kick(player.Name, reason);
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /kick <player> <reason>", player)
                break;
            }
            case "slap":
            {
                if(text && NumTok(text, " ") >= 2) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        if(targetplr.IsSpawned) {
                            targetplr.Slap(player, reason);
                        }
                        
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /slap <player> <reason>", player)                
                break;
            }
            case "drown":
            {
                if(text && NumTok(text, " ") >= 2) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        if(targetplr.IsSpawned) {
                            targetplr.Drown(player, reason);
                        }
                        
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /drown <player> <reason>", player)                
                break;
            }


        }
    }
}