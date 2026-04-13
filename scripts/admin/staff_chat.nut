COLOR_STAFFCHAT <- "[#c5eae7]"

function StaffChat(admin, msg)
{
    for(local i = 0; i < GetMaxPlayers(); ++i)
    {
        if(GetPlayer(i))
        {
            local player = GetPlayer(i);
            if(playerData[player.ID].adminLevel >= 1)
            {
                MessagePlayer(COLOR_STAFFCHAT + "[STAFF CHAT] " + admin + ": " + msg, player);
            }
        }
    }
}