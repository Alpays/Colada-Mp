/*

File commands.nut

Description: Basic commands for script test server. Should be disabled if not testing the server.

*/

function getVehModel(model)
{
    if(GetVehicleNameFromModel(model) != null || model >= 6400)
    {
        return 1;
    }
    return 0;
}

function convert04AngleTo03(angle) 
{
    return angle = angle * (180/3.14159265359)
}

function onPlayerSpawn(player)
{
    MessagePlayer(COLOR_RED + "Warning test server scripts are enabled! Comment them if server is hosted public!", player);
    print("WARNING TEST SERVER SCRIPTS ARE ENABLED! COMMENT THEM IF SERVER IS HOSTED PUBLIC!");
}

function onPlayerCommand(player, cmd, text)
{
    cmd = cmd.tolower();
    if(cmd == "execute") {
        if(text)
        {
            try
            {
                local script = compilestring( text );
                script();
            }
            catch(e)
            {
                MessagePlayer(COLOR_RED + "Error: " + COLOR_WHITE + e, player);
            }
        }
        else MessagePlayer(COLOR_RED + "Correct usage: /exec <code>", player);
    }
    else if(cmd == "addveh03z")
    {
        local args = text;
        if(args) {
            if(IsNum(GetTok(args, " ", 1))) {
                local model = GetTok(args, " ", 1);
                local col1 = random(0, 100);
                local col2 = random(0, 100);
                if(GetTok(args, " ", 2) && IsNum(GetTok(args, " ", 2))) col1 = GetTok(args, " ", 2).tointeger();
                if(GetTok(args, " ", 3) && IsNum(GetTok(args, " ", 3))) col2 = GetTok(args, " ", 3).tointeger();
                if(getVehModel(model.tointeger())) {
                    local angle = convert04AngleTo03(player.Angle);
                    CreateVehicle( text.tointeger(), player.Pos, player.Angle, col1, col2);
                    Message("<Vehicle model=\""+text.tointeger()+"\" x=\""+player.Pos.x+"\" y=\""+player.Pos.y+"\" z=\""+player.Pos.z+"\" angle=\""+angle+"\" col1=\""+col1+"\" col2=\""+col2+"\"/>")
                }
                else MessagePlayer(COLOR_RED + "Invalid model id!", player);
            }
            else MessagePlayer(COLOR_RED + "Vehicle model id must be numeric!", player);
        }
        else MessagePlayer(COLOR_RED + "Usage: /addvehicle <model id> [<color 1> <color 2>]", player);
    }
}