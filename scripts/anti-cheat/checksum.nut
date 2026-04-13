pinglimit <- 350;
fpslimit <- 24;
warnlimit <- 5;
jitterlimit <- 100;

antiCheat_fpsLimit <- 75;

function onPlayerModuleList(player, list)
{
    print(list);
	local rows = ::split(list, "\n");
	foreach(row in rows){
		row = row.tolower();
		local asi_search = ::regexp(@"\w+\.asi$").search(row);
		if(null != asi_search){
			local asi = row.slice(asi_search.begin,asi_search.end);
			if("mp3dec.asi" != asi){
                player.Kick("ANTI-CHEAT", "External .asi file detected. (0x03)");
				return;
			}
		}

	}
}

function fileChecksum(player)
{
    player.RequestModuleList();
}

function fileChecksumRoutine() {
    for(local i = 0; i < GetMaxPlayers(); ++i) {
        if(FindPlayer(i)) fileChecksum(FindPlayer(i))
    }
}

function checkPlayer()
{   
    for(local i = 0; i < GetMaxPlayers(); ++i)
    {
        local player = GetPlayer(i);
        if(player && player.IsSpawned)
        {
            if(player.Ping > pinglimit)
            {
                playerData[player.ID].ping_warn++;
                MessagePlayer(COLOR_RED + "Warning: Your Ping is higher than the limit (" + player.Ping + "/" + pinglimit + ") fix it avoid to getting kicked. (" + playerData[player.ID].ping_warn + "/" + warnlimit + ")", player);
            }
            if(player.FPS < fpslimit)
            {
                playerData[player.ID].fps_warn++;
                MessagePlayer(COLOR_RED + "Warning: Your FPS is lower than the limit (" + player.FPS + "/" + fpslimit + ") fix it avoid to getting kicked. (" + playerData[player.ID].fps_warn + "/" + warnlimit + ")", player);
            }
            if(player.FPS >= antiCheat_fpsLimit)
            {
                bans.TempBan(player.Name, "Anti-Cheat", "2w", "Cheat Detected (0x05)");
            }
            if(playerData[player.ID].recent_ping > 0)
            {
                local jitter = player.Ping - playerData[player.ID].recent_ping;
                if(jitter > jitterlimit)
                {
                    playerData[player.ID].jitter_warn++;
                    MessagePlayer(COLOR_RED + "Warning: Your jitter is higher than the limit (" + jitter + "/" + jitterlimit + ") fix it avoid to getting kicked. (" + playerData[player.ID].jitter_warn + "/" + warnlimit + ")", player);
                }
                if(playerData[player.ID].jitter_warn == warnlimit) player.Kick("Server", "Jitter is higher than the limit. (" + jitter + "/" + jitterlimit + ")");
            }
            if(playerData[player.ID].fps_warn == warnlimit) {
                player.Kick("Server", "FPS is lower than the limit. Minimum FPS: " + fpslimit);
                return;
            }
            if(playerData[player.ID].ping_warn == warnlimit) player.Kick("Server", "Ping is higher than the limit. Maximum Ping: " + pinglimit);
            playerData[player.ID].recent_ping = player.Ping;
        }
    }
}

NewTimer("checkPlayer", 15 * 1000, 0)

NewTimer("fileChecksumRoutine", 300 * 1000, 0)