/*

File: properties.nut

Description: Command to add property to the properties database.

*/

function onPlayerCommand(player, cmd, text)
{
    local adminlevel = playerData[player.ID].adminLevel;
    switch(cmd.tolower())
    {
        case "addprop":
        {
            if(adminlevel == 3)
            {
                if(text && NumTok(text, " ") >= 3 && IsNum(GetTok(text, " ", 1)))
                {
                    if(IsNum(GetTok(text, " ", 2)))
                    {
                        local ptype = GetTok(text, " ", 2).tointeger();
                        if(ptype == 0 || ptype == 1)
                        {
                            if(player.IsSpawned)
                            {
                                local price =    GetTok(text, " ", 1).tointeger();
                                local propName = GetTok(text, " ", 2 NumTok(text, " "));
                                local x = player.Pos.x, y = player.Pos.y, z = player.Pos.z;
                                QuerySQL(properties.db, format("INSERT INTO PROPERTIES(name,owner,shared,type,x,y,z,price) VALUES('%s','%s','%s','%d','%f','%f','%f','%d')", propName, "-", "-", ptype ,x, y, z, price));
                                MessagePlayer(COLOR_BLUE + propName + COLOR_WHITE + " has been added into the database! It will appear on the next server start!", player);
                            }
                            else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
                        }
                        else MessagePlayer(COLOR_RED + "Incorrect property type!", player);
                    }
                    else MessagePlayer(COLOR_RED + "Correct usage: /addprop <price> <type> <name>", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /addprop <price> <name>", player);
            }
            break;
        }
    }
}