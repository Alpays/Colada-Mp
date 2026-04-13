/*

File: player_info.nut

Description: This event is called when a player joins

*/


function onPlayerInfo(player)
{
    StaffChat("Server", "Player: " + player.Name + " is connecting with ip address: " + player.IP);
}