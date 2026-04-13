/*

File: race_editor_commands.nut

Description: Race Editor commands.

*/

function onPlayerRaceEditorCommand(player, cmd, text)
{
    if(playerData[player.ID].adminLevel >= 2) 
    {
        switch(cmd.tolower())
        {
            case "recommands":
            {
                MessagePlayer(COLOR_BLUE + "List of the race editor commands: " + COLOR_WHITE + "/recommands, /createrace, /deleterace, /setracestart, /setraceveh, /addracecp, /reseteditor, /saverace, /reworld", player);
                MessagePlayer(COLOR_BLUE + "In order to create a race first use, /createrace <name>, get to the starting point, use /setracestart, add some checkpoints with /addracecp then use /saverace", player);
                break;
            }
            case "createrace":
            {
                if(text)
                {
                    local q = QuerySQL(raceDb, "SELECT * FROM races WHERE name='"+text+"'");
                    if(q)
                    {
                        MessagePlayer(COLOR_RED + "There's an existing race track with the name of " + text, player);
                        FreeSQLQuery(q);
                    }
                    else {
                        if(!raceEditor.active)
                        {
                            raceEditor.active = true;
                            raceEditor.trackName = text;
                            raceEditor.author = player.Name;
                            StaffChat("Race-Editor", COLOR_GREEN + "New race has been created with the name of " + COLOR_WHITE + text + COLOR_GREEN + " by " + COLOR_WHITE + player.Name + COLOR_GREEN + " check out /recommands and modify it before saving the track.");
                            StaffChat("Race-Editor", COLOR_GREEN + "You can use /reworld to switch between freeroam and race editor worlds to see visulation of whats been added!");
                        }
                        else MessagePlayer(COLOR_RED + "A race is already being developed with the name of " + raceEditor.trackName + " use /reseteditor if you want to scrap it.", player);
                    }
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /createrace <race name>", player);
                break;
            }
            case "deleterace":
            {
                if(text && IsNum(text))
                {
                    local q = QuerySQL(raceDb, "SELECT * FROM races WHERE id='"+text.tointeger()+"'");
                    if(q)
                    {
                        QuerySQL(raceDb, "DELETE FROM races WHERE id='"+text.tointeger()+"'");
                        MessagePlayer(COLOR_BLUE + "You've successfully deleted the race " + GetSQLColumnData(q, 1), player);
                        FreeSQLQuery(q);
                    }
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /deleterace <race id>", player);
                break;
            }
            case "setracestart":
            {
                if(raceEditor.active)
                {
                    raceEditor.startingPos = player.Pos;
                    raceEditor.startingAngle = player.Angle;
                    StaffChat("Race-Editor", COLOR_GREEN + "Starting position has been set to " + COLOR_WHITE + player.Name + COLOR_GREEN + "'s position!" + COLOR_WHITE + "(" + player.Pos.x + "," + player.Pos.y + "," + player.Pos.z + ")")
                }
                else MessagePlayer(COLOR_RED + "You can't use this command when race editor is not active. Use /createrace <race name> first.", player);
                break;
            }
            case "addracecp":
            {
                if(raceEditor.active)
                {
                    if(raceEditor.cpCount < raceEditor.maxCp)
                    {
                        raceEditor.cpCount++;
                        raceEditor.checkpoints.resize(raceEditor.cpCount)
                        raceEditor.checkpoints.insert(raceEditor.cpCount - 1, player.Pos)
                        raceEditor.visCp.resize(raceEditor.cpCount);
                        raceEditor.visCp.insert(raceEditor.cpCount - 1, CreateCheckpoint(null, raceEditor.world , false, ::Vector(player.Pos.x,player.Pos.y,player.Pos.z), ::RGB(255,255,255), 4));
                        StaffChat("Race-Editor", COLOR_GREEN + "A Checkpoint has been added by " + player.Name + "! New CP Count: " + raceEditor.cpCount + "/" + raceEditor.maxCp);                    
                    }
                }
                else MessagePlayer(COLOR_RED + "You can't use this command when race editor is not active. Use /createrace <race name> first.", player);
                break;
            }
            case "setraceveh":
            case "setracevehicle":
            {
                if(text && IsNum(text))
                {
                    if(raceEditor.active)
                    {
                        local veh = text.tointeger();
                        if(getVehicleNameFromModel(veh) != "Unknown")
                        {
                            raceEditor.vehicle = veh;
                            StaffChat("Race-Editor", COLOR_GREEN + "Race " + raceEditor.trackName + "'s vehicle has been set to " + getVehicleNameFromModel(veh) + " by " + player.Name);
                        }
                        else MessagePlayer(COLOR_RED + "Unknown vehicle model id!", player);
                    }
                    else MessagePlayer(COLOR_RED + "You can't use this command when race editor is not active. Use /createrace <race name> first.", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /setracevehicle <model id>", player);
                break;
            }
            case "resetraceeditor":
            case "reseteditor:":
            {
                if(raceEditor.active)
                {
                    raceEditor.reset();
                }
                else MessagePlayer(COLOR_RED + "You can't use this command when race editor is not active. Use /createrace <race name> first.", player);
                break;
            }
            case "saverace":
            {
                if(raceEditor.active)
                {
                    if(raceEditor.cpCount > 0 && raceEditor.startingPos != null)
                    {
                        MessagePlayer(COLOR_BLUE + "Saving the race into the database...", player);
                        QuerySQL(raceDb, format("INSERT INTO races(name, author, startx, starty, startz, startangle, vehicle, best, besttime) VALUES('%s', '%s', '%f', '%f', '%f', '%f', '%d', '%s', '%d')", raceEditor.trackName, raceEditor.author, raceEditor.startingPos.x, raceEditor.startingPos.y, raceEditor.startingPos.z, raceEditor.startingAngle, raceEditor.vehicle, "-", 9999));
                        
                        local q = ::QuerySQL(raceDb, "SELECT last_insert_rowid() FROM races")
                        local raceId = GetSQLColumnData(q, 0);
                        ::FreeSQLQuery(q);

                        for(local i = 0; i < raceEditor.checkpoints.len() - 1; ++i)
                        {
                            QuerySQL(raceDb, format("INSERT INTO checkpoints(raceid, cpid, x, y, z) VALUES('%d', '%d', '%f', '%f', '%f')", raceId, i + 1, raceEditor.checkpoints[i].x, raceEditor.checkpoints[i].y, raceEditor.checkpoints[i].z));
                        }

                        StaffChat("Race-Editor", "A New Race track named " + raceEditor.trackName + " has been added to the database it can be played now.");
                        StaffChat("Race-Editor", "has been reset.");
                        raceEditor.reset();
                    }
                    else MessagePlayer(COLOR_RED + "Error saving the race. Make sure you at least added checkpoints and set the starting position", player);
                }
                else MessagePlayer(COLOR_RED + "There's no race making in progress!", player);
                break;
            }
            case "reworld":
            {
                switch(player.World)
                {
                    case 1:    
                        player.World = raceEditor.world;
                        MessagePlayer(COLOR_BLUE + "You entered race editor world! You can see the checkpoints you added here!", player);
                        break;
                    default:
                        player.World = 1;
                        MessagePlayer(COLOR_BLUE + "You got back to the default world.", player);
                }
            }
        }
    }
}