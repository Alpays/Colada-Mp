/*

File: kill_messages.nut

Description: Custom kill messages.

*/

function getKillMessage(weapon)
{
    switch(getWeaponType(weapon))
    {
        case "Fist":       return "fisted";
        case "Sniper":     return "sniped";
        case "Submachine": return "rifled";
        case "Pistol":     return "whipped";
        default:
        {
            local a = rand() % 4;
            switch(a)
            {
                case 0:           
                    return "killed";
                case 1:
                    return "ended";
                case 2:
                    return "cancelled";
                case 3:
                    return "slaughtered";
            }
        }
    }
}

function onPlayerKill(killer, player, reason, bodypart) {
    Message(COLOR_BLUE + killer.Name + COLOR_WHITE + " " + getKillMessage(reason) + " " + COLOR_BLUE + player.Name + COLOR_WHITE + " (" + getWeaponName(reason) + ") (" + getBodypartName(bodypart) + ")" );
}

function onPlayerDeath(player, reason)
{
    switch(reason)
    {
        case 51: Message(COLOR_BLUE + player.Name + COLOR_WHITE + " exploded."); break;
        case 70: Message(COLOR_BLUE + player.Name + COLOR_WHITE + " commited suicide."); break;
        case 44: Message(COLOR_BLUE + player.Name + COLOR_WHITE + " fell."); break;
        case 43: Message(COLOR_BLUE + player.Name + COLOR_WHITE + " drowned."); break;
        case 31: Message(COLOR_BLUE + player.Name + COLOR_WHITE + " burned."); break;
        default: Message(COLOR_BLUE + player.Name + COLOR_WHITE + " died.");
    }    
}