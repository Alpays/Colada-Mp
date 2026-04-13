/*

File: guide.nut

Description: Adds a rule and command list to help the players.

*/

accCmdList <- "/register /login /changepass /autologin";
genericCmdList <- "/credits /rules /heal /wep /spawnwep /buywep (Ammu-Nation only) /me /diepos /spree /vc /spec /fps /ping /admins";
animCmdList <- "/dance /sit /handsup";
statsCmdList <- "/stats /resetstats /topkillers /topspree";
carCmdList <- "/buycar(1-2) /getcar(1-2) /sellcar(1-2) /mycars";
raceCmdList <- "/startrace /joinrace /listraces";
propCmdList <- "/buyprop /shareprop /exitprop";
cmdList <- accCmdList + " " + genericCmdList + " " + animCmdList + " " + statsCmdList + " " + carCmdList + " " + raceCmdList + " " + propCmdList;

modCmdList <- "/setweather /settime /kick /drown /slap /sc ";
adminCmdList <- "/ban /tempban /unban /unbanip /getip /togglecrouch /goto /bring /bringall /reward /givewep /givewepall /tempveh /mypos /recommands /createrace /deleterace /addracecp /setracestart /setracevehicle /resetraceeditor /saverace "
managerCmdList <- "/addvehicle /addprop /setlevel /exec";

ruleList <- "Advertising, death evading, stats padding, ban evading, using vpn, game modifications/hacks, spawn killing and exploiting script bugs.";

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower())
    {
        case "cmds":
        case "commands":
        case "cmd":
        {
            if(!text) {
                MessagePlayer(COLOR_BLUE + "List of player commands: " + COLOR_WHITE + cmdList, player);
                MessagePlayer(COLOR_BLUE + "If you want to see commands categorized use /cmd <acc,gen,anim,stats,car,race,prop,admin>", player);
            }
            else if(text == "acc" || text == "account") 
                MessagePlayer(COLOR_BLUE + "List of account commands: " + COLOR_WHITE + accCmdList, player);
            else if(text == "gen" || text == "generic") 
                MessagePlayer(COLOR_BLUE + "List of generic commands: " + COLOR_WHITE + genericCmdList, player);
            else if(text == "anim" || text == "anim")
                MessagePlayer(COLOR_BLUE + "List of animation commands: " + COLOR_WHITE + animCmdList, player);
            else if(text == "stats" || text == "statics")
                MessagePlayer(COLOR_BLUE + "List of stats commands: " + COLOR_WHITE + statsCmdList, player);
            else if(text == "car")
                MessagePlayer(COLOR_BLUE + "List of car ownership commands: " + COLOR_WHITE + carCmdList, player);
            else if(text == "race")
                MessagePlayer(COLOR_BLUE + "List of race commands: " + COLOR_WHITE + raceCmdList, player);
            else if(text == "prop" || text == "property")
                MessagePlayer(COLOR_BLUE + "List of property commands: " + COLOR_WHITE + propCmdList, player);
            else if(text == "admin")
                switch(playerData[player.ID].adminLevel) // 1 = Moderator, 2 = Admin, 3 = Manager
                {
                case 3:
                    MessagePlayer(COLOR_BLUE + "List of manager commands: " + COLOR_WHITE + managerCmdList, player);
                case 2:
                    MessagePlayer(COLOR_BLUE + "List of admin commands: " + COLOR_WHITE + adminCmdList, player);
                case 1:
                    MessagePlayer(COLOR_BLUE + "List of moderator commands: " + COLOR_WHITE + modCmdList, player);
                }
            break;
        }
        case "rules":
        {
            MessagePlayer(COLOR_BLUE + "Following is not allowed: " + COLOR_WHITE + ruleList, player);
            break;
        }
    }
}