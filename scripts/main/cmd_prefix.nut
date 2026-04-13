/*

File: cmd_prefix.nut

Description: Ability to use commands with '!' prefix.

*/

function onPlayerChat(player, msg)
{
    if(msg.find("!") == 0 && msg.len() > 1)
    {
        local cmd = null;
        local args = msg.find(" ");
        if(args == null)
        {
            cmd = msg.slice(1, msg.len());
        }
        else {
            cmd = msg.slice(1, args);
            args = msg.slice(args + 1, msg.len());
        }
        onPlayerCommand(player, cmd, args);
        if(isAccountCommand(cmd.tolower())) 
        {
            return 0;
        }
    }
    return 1;
}