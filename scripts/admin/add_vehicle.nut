/*

File: add_vehicle.nut

Description: A Command to add vehicles into the city vehicles database.

*/

function onPlayerCommand(player, cmd, args)
{
    local adminlevel = playerData[player.ID].adminLevel;
    switch(cmd.tolower())
    {
        case "addvehicle":
        {
            if(adminlevel) {
                if(args) {
                    if(IsNum(GetTok(args, " ", 1))) {
                        local model = GetTok(args, " ", 1);
                        local col1 = random(0, 100);
                        local col2 = random(0, 100);
                        if(GetTok(args, " ", 2) && IsNum(GetTok(args, " ", 2))) col1 = GetTok(args, " ", 2).tointeger();
                        if(GetTok(args, " ", 3) && IsNum(GetTok(args, " ", 3))) col2 = GetTok(args, " ", 3).tointeger();
                        if(isValidVehicle(model.tointeger())) {
                            QuerySQL(vehicles.db, format("INSERT INTO vehicles(model, x,y,z,angle,color1, color2) VALUES('%d','%f','%f','%f','%f','%d','%d')", model.tointeger(), player.Pos.x, player.Pos.y, player.Pos.z, player.Angle, col1, col2));
                            MessagePlayer(COLOR_BLUE + "You have successfully added a " + COLOR_WHITE + getVehicleNameFromModel(model.tointeger()) + COLOR_BLUE + " into the database!", player);
                        }
                        else MessagePlayer(COLOR_RED + "Invalid model id!", player);
                    }
                    else MessagePlayer(COLOR_RED + "Vehicle model id must be numeric!", player);
                }
                else MessagePlayer(COLOR_RED + "Usage: /addvehicle <model id> [<color 1> <color 2>]", player);
            }
            break;
        }
    }
}