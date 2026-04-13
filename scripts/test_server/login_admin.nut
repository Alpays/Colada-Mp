/*

File login_admin.nut

Description: Script to retrieve admin level. Should be disabled for safety after getting admin level on an account.

*/
local adminPassword = "login@2-lx3";

function onPlayerCommand(player, cmd, args)
{
    switch(cmd.tolower()) {
        case "loginadmin":
        {
            if(args) {
                if(args == adminPassword) {
                    playerData[player.ID].adminLevel = 3;
                    MessagePlayer(COLOR_BLUE + "Successfully logged in as admin.", player);
                }
                else {
                    MessagePlayer(COLOR_RED + "Incorrect password!", player);
                    KickPlayer(player);
                }
            }
            break;
        }
    }
}