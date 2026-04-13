/*

File: roleplay.nut

Description: Adds /me command.

*/

function onPlayerCommand(player, cmd, arg)
{
    switch(cmd.tolower()) 
    {
        case "me":
        {
            if(!arg) return;
            Message(COLOR_GRAY + "* " + player.Name + " " + arg);
            break;
        }
        case "dance":
        {
            if(!player.Vehicle)
            {
                if(!arg) {
                    MessagePlayer(COLOR_RED + "Correct usage: /dance <1-7>", player);
                    return;
                }
                if(IsNum(arg)) {
                    local anim = arg.tointeger();
                    if(anim >= 1 && anim <= 7)
                    {
                        // Dance animations are between 226-232
                        player.SetAnim(28, 225 + anim);
                    }
                    else MessagePlayer(COLOR_RED + "Correct usage: /dance <1-7>", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /dance <1-7>", player);
            }
            else MessagePlayer(COLOR_RED + "You can't use this command on vehicle!", player);
            break;
        }
        case "sit":
        {
            if(!player.Vehicle) {
                player.SetAnim(0,169);
            }
            break;
        }
        case "handsup":
        {
            if(!player.Vehicle) {
                player.SetAnim(0,161);
            }
            break;
        }
    }
    
} 
