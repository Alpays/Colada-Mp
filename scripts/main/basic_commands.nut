function getAdminLevel(level)
{
    switch(level)
    {
        case 1:
            return "Moderator";
            break;
        case 2:
            return "Administrator";
            break;
        case 3:
            return "Server Manager";
    }
}

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower())
    {
        case "fps":
        case "ping":
        {
            if(!text) {
                MessagePlayer(COLOR_GRAY + "Your FPS: " + COLOR_WHITE + player.FPS + COLOR_GRAY + " Your ping: " + COLOR_WHITE + player.Ping, player);
            } 
            else 
            {
                local plr = GetPlayer(text)
                if(plr)
                {   
                    MessagePlayer(COLOR_GRAY + plr.Name +"'s FPS: " + COLOR_WHITE + plr.FPS + COLOR_GRAY + " ping: " + COLOR_WHITE + plr.Ping, player );
                } else MessagePlayer(COLOR_RED + "Error: Player not found!", player);
            }
            break;
        }
        case "report":
        {
            if(text) {
                if(NumTok(text, " ") >= 2)
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        StaffChat("Server", player.Name + " has reported " + targetplr.Name + " reason: " + reason );
                        MessagePlayer(COLOR_GREEN + "The report has been sent to all admins in game, thank you for reporting.", player);
                    }
                    else MessagePlayer(COLOR_RED + "Target player not found!", player);
                }
                else MessagePlayer(COLOR_RED + "Corect usage: /report <player> <reason>", player);
            } else MessagePlayer(COLOR_RED + "Corect usage: /report <player> <reason>", player);
            break;
        }
        case "admin":
        case "admins":
        {
            local playercount = 0;
            local playerlist = "";
            for(local i = 0; i < GetMaxPlayers(); ++i) {
                local plr = GetPlayer(i)
                if(plr) {
                    if(playerData[i].adminLevel >= 1) {
                        playerlist += plr.Name + " (" + getAdminLevel(playerData[plr.ID].adminLevel) + ") ";
                        ++playercount;
                    }
                } 
            } 
            if(playercount == 0) 
            {
                MessagePlayer(COLOR_RED + "No admins online!", player)
                return;
            }
            MessagePlayer(COLOR_BLUE + "Admins online (" + playercount + "): " + COLOR_WHITE + playerlist, player);
            break;
        }
        case "resetstats":
        {
            if(playerData[player.ID].registered && playerData[player.ID].logged)
            {
                if(playerData[player.ID].confirm) {
                    playerData[player.ID].kills = 0;
                    playerData[player.ID].deaths = 0;
                    playerData[player.ID].confirm = false;
                    MessagePlayer(COLOR_GREEN + "You have successfully reset your stats!", player);
                }
                else {
                    MessagePlayer(COLOR_RED + "Warning: This command resets your kills and death! In order to confirm this action type this command again.", player);
                    playerData[player.ID].confirm = true;
                }
            }
            break;
        }
        case "topkillers":
        {   
            local list = COLOR_BLUE +  "Top Killers: " + COLOR_WHITE;
            local q = QuerySQL(accounts.db, "SELECT * FROM accounts ORDER BY kills DESC LIMIT 5");
            if(q) {
                while(::GetSQLColumnData(q, 0)) {
                    local name = GetSQLColumnData(q, 1);
                    local kill = GetSQLColumnData(q, 7);
                    GetSQLNextRow(q);
                    list += name + " (" + kill + ")" + " ";
                }
                FreeSQLQuery(q);
            }
            MessagePlayer(list, player);
            break;
        }
        case "topspree":
        {
            local list = COLOR_BLUE +  "Top Sprees: " + COLOR_WHITE;
            local q = QuerySQL(accounts.db, "SELECT * FROM accounts ORDER BY topspree DESC LIMIT 5");
            if(q) {
                while(::GetSQLColumnData(q, 0)) {
                    local name = GetSQLColumnData(q, 1);
                    local spree = GetSQLColumnData(q, 9);
                    GetSQLNextRow(q);
                    list += name + " (" + spree + ")" + " ";
                }
                FreeSQLQuery(q);
            }
            MessagePlayer(list, player);
            break;
        }
        case "credits":
        {
            MessagePlayer(COLOR_BLUE + "Server Credits: " + COLOR_WHITE + "[VU]Alpays (Developer/Mapping) Hanney (Hosting)", player);
            MessagePlayer(COLOR_BLUE + "Used Content: " + COLOR_WHITE + "Sniper Laser (vito) Vercetti Mansion/Drift Handling/Flying Car (Sebastian) Map Fixes and Improvements (rww) Modular script template (dracc) Snow weather (Kelvin)", player);
        }
    }
}