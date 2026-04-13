/*

File: spree.nut

Description: Killing Spree system.

*/

function onPlayerKill(killer, player, reason, bodypart) {
    if(playerData[killer.ID].spree % 5 == 0) {
        local spree_reward = playerData[killer.ID].spree * 100;
        Message(COLOR_BLUE + killer.Name + COLOR_WHITE + " is on a killing spree of " + COLOR_BLUE + playerData[killer.ID].spree + COLOR_WHITE + "! " + COLOR_WHITE + "Reward: " + COLOR_BLUE + spree_reward + "$")
        killer.IncCash(spree_reward);
        killer.Health = 100;
        if(playerData[killer.ID].spree % 50 == 0)
        {
            killer.GiveWeapon(WEP_MINIGUN, 99);
            Message(COLOR_PINK + "Kill Frenzy Reward! giving " + killer.Name + " a Minigun with 99 ammo.");
            Announce("~o~KILL FRENZY!", killer, 6);
        }
        else {
            Announce("~o~Killing Spree!", killer, 5);
        }
    }


    if(playerData[player.ID].spree >= 5) {
        Message(COLOR_BLUE + player.Name + "'s" + COLOR_WHITE + " killing spree of " + COLOR_BLUE + playerData[player.ID].spree + COLOR_WHITE + " has been ended by " + COLOR_BLUE + killer.Name);
    }

    playerData[player.ID].spree = 0;
}

function onPlayerDeath(player, reason)
{
    if(playerData[player.ID].spree >= 5) {
        Message(COLOR_BLUE + player.Name + COLOR_WHITE + " has ended their own killing spree of " + COLOR_BLUE + playerData[player.ID].spree)
    }
    playerData[player.ID].spree = 0;
}

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower()) {
        case "spree": {
            local playercount = 0;
            local playerlist = "";
            for(local i = 0; i < GetMaxPlayers(); ++i) {
                local plr = GetPlayer(i)
                if(plr) {
                    if(playerData[i].spree >= 5) {
                        playerlist += plr.Name + "(" + playerData[plr.ID].spree + ") ";
                        ++playercount;
                    }
                } 
            } 
            if(playercount == 0) 
            {
                MessagePlayer(COLOR_RED + "No player is on a killing spree!", player)
                return;
            }
            MessagePlayer(COLOR_BLUE + "Players on spree (" + playercount + "): " + COLOR_WHITE + playerlist, player);
        }
    }
}