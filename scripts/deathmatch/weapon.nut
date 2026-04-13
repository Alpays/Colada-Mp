/*

File: weapon_nut.

Description: /wep and /spawnwep commands.

*/

function onPlayerSpawn(player) {
    player.SetSpawnWeps();
}

function CPlayer::SetSpawnWeps()
{
    for(local i = 0; i < ::playerData[ID].spawnweps.len(); ++i) 
    {
        if(::playerData[ID].spawnweps[i] != null) 
            SetWeapon( ::playerData[ID].spawnweps[i],9999)
    }
}

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower())
    {
        case "wep":
        case "we":
        case "weapon":
        case "getwep":
        {
            if(text) 
            {
                local wepid = 0;
                local weplist = "";
                if(text) {
                    local i = 1;
                    while(GetTok(text, " ", i)) {
                        switch(getWeaponID(GetTok(text, " ", i)))
                        {
                            case WEP_MINIGUN: case WEP_RPG: case WEP_GRENADE: 
                            case WEP_REMOTE: case WEP_TEARGAS: case WEP_MOLOTOV: 
                            case WEP_ROCKET: case WEP_CHAINSAW: case WEP_FLAMETHROWER:
                            {
                                local disallowedwep = getWeaponID( GetTok(text, " ", i) ); 
                                disallowedwep = getWeaponName(disallowedwep);
                                MessagePlayer(COLOR_RED + "You can't get " + disallowedwep, player);
                                break;
                            }
                            default:
                            {
                                player.SetWeapon(getWeaponID(GetTok(text, " ", i)), 9999)
                                wepid = getWeaponID(GetTok(text, " ", i))
                                weplist+= getWeaponName(wepid) + " ";
                            }
                        }
    
                        ++i;
                    }
                    if(weplist != "")
                    {
                        MessagePlayer(COLOR_YELLOW + "You have received the following weapons: " + COLOR_WHITE + weplist, player);
                    } 
                } else MessagePlayer(COLOR_RED + "Correct usage: /wep <weapon list>", player)
            }
            else MessagePlayer(COLOR_RED + "Correct usage: /wep <weapon 1, weapon 2,...>", player)
            break;            
        }
        case "spawnwep":
        {
            if(text) 
            {
                local wepid = 0;
                local weplist = "";
                if(text) {
                    local i = 1;
                    playerData[player.ID].spawnweps.clear();
                    playerData[player.ID].spawnweps.resize(NumTok(text, " "), null);
                    while(GetTok(text, " ", i)) {
                        switch(getWeaponID(GetTok(text, " ", i)))
                        {
                            case WEP_MINIGUN: case WEP_RPG: case WEP_GRENADE: 
                            case WEP_REMOTE: case WEP_TEARGAS: case WEP_MOLOTOV: 
                            case WEP_ROCKET: case WEP_CHAINSAW: case WEP_FLAMETHROWER:
                            {
                                local disallowedwep = getWeaponID( GetTok(text, " ", i) ); 
                                disallowedwep = getWeaponName(disallowedwep);
                                MessagePlayer(COLOR_RED + "You can't get " + disallowedwep, player);
                                break;
                            }
                            default:
                            {
                                playerData[player.ID].spawnweps.insert(i, getWeaponID(GetTok(text, " ", i)))
                                wepid = getWeaponID(GetTok(text, " ", i))
                                weplist+= getWeaponName(wepid) + " ";
                            }
                        }
    
                        ++i;
                    }
                    if(weplist != "")
                    {
                        player.Disarm();
                        player.SetSpawnWeps();
                        MessagePlayer(COLOR_YELLOW + "Your spawnwep list is: " + COLOR_WHITE + weplist, player);
                    } 
                } else MessagePlayer(COLOR_RED + "Correct usage: /spawnwepwep <weapon list>", player)
            }
            else MessagePlayer(COLOR_RED + "Correct usage: /spawnwep <weapon 1, weapon 2,...>", player)
            break;
        }
        break;
    }
}