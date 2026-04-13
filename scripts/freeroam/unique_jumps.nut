/*

File: unique_jumps.nut

Description: Unique Stunt Jump pickups, inspired from singleplayer of Vice City.

*/


class stuntJumps
{
    jumps = array( 20, null );

    jumpPickups =
    [
        [Vector(265.963, -485.179, 15.58)],
        [Vector(433.218, -120.143, 21.64)],
        [Vector(459.969, -394.807, 18.46)],
        [Vector(453.597, -511.858, 23.01)],
        [Vector(364.969, -720.905, 26.76)],

        [Vector(-672.87, 1175.990, 34.83)],
        [Vector(-617.10, 636.692, 27.26)],
        [Vector(-1006, -48.82, 16.29)],
        [Vector(-924.048, -112.481, 22.89)],
        [Vector(-1087, -162, 28.63)],

        [Vector(50.43, -805.09, 10.05)],
        [Vector(-790, 1098, 20.57)],
        [Vector(-529, 865, 86.82)],
        [Vector(-838, 1168, 31.91)],
        [Vector(-791, 1282, 29.41)],

        [Vector(-741, 1300, 27.47)],
        [Vector(-679, 1323, 26.48)],
        [Vector(-1447.26, 1437, 316.23)],
        [Vector(-1405, 925, 278)],
        [Vector(-1563, -1238, 21.81)],
    ]

    db = null;

    function onScriptLoad()
    {
        for(local i = 0; i < jumpPickups.len(); ++i) {
            jumps[i] = ::CreatePickup(375, jumpPickups[i][0]).ID;
        }

        db = ConnectSQL("unique_jumps.db"); 

        ::QuerySQL(db, "CREATE TABLE IF NOT EXISTS stunts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, completed INTEGER DEFAULT 0, stunt1 BOOL DEFAULT FALSE, stunt2 BOOL DEFAULT FALSE, stunt3 BOOL DEFAULT FALSE, stunt4 BOOL DEFAULT FALSE, stunt5 BOOL DEFAULT FALSE, stunt6 BOOL DEFAULT FALSE, stunt7 BOOL DEFAULT FALSE, stunt8 BOOL DEFAULT FALSE, stunt9 BOOL DEFAULT FALSE, stunt10 BOOL DEFAULT FALSE, stunt11 BOOL DEFAULT FALSE, stunt12 BOOL DEFAULT FALSE, stunt13 BOOL DEFAULT FALSE, stunt14 BOOL DEFAULT FALSE, stunt15 BOOL DEFAULT FALSE, stunt16 BOOL DEFAULT FALSE, stunt17 BOOL DEFAULT FALSE, stunt18 BOOL DEFAULT FALSE, stunt19 BOOL DEFAULT FALSE, stunt20 BOOL DEFAULT FALSE)");
    }

    function onScriptUnload()
    {
        ::DisconnectSQL(db);
    }

    function RegisterStuntDatabase(player)
    {
        local name = player.Name;
        ::QuerySQL(db, "INSERT INTO stunts(name) VALUES('"+name+"')");
    }

    function LoadStunts(player)
    {
        local ID = player.ID;
        local Name = player.Name;
        local q = ::QuerySQL(db, "SELECT * FROM stunts WHERE name='"+Name+"' COLLATE NOCASE");
        if(q) {
            for(local i = 0; i < playerData[ID].stunts.len(); ++i) {
                playerData[ID].stunts[i] = ::GetSQLColumnData(q, i + 3); 
                playerData[ID].stuntsCompleted = ::GetSQLColumnData(q, 2);
            }
            ::FreeSQLQuery(q);
        }
    }

    function UpdateStunts(player)
    {
        local ID = player.ID;
        local Name = player.Name;
        ::QuerySQL(db, format("UPDATE stunts SET completed='%d', stunt1='%d', stunt2='%d', stunt3='%d', stunt4='%d', stunt5='%d', stunt6='%d', stunt7='%d', stunt8='%d', stunt9='%d', stunt10='%d', stunt11='%d', stunt12='%d', stunt13='%d', stunt14='%d', stunt15='%d', stunt16='%d', stunt17='%d', stunt18='%d', stunt19='%d', stunt20='%d' WHERE name='%s' COLLATE NOCASE", playerData[player.ID].stuntsCompleted, playerData[ID].stunts[0], playerData[ID].stunts[1], playerData[ID].stunts[2], playerData[player.ID].stunts[3], playerData[player.ID].stunts[4], playerData[ID].stunts[5], playerData[ID].stunts[6], playerData[ID].stunts[7], playerData[ID].stunts[8], playerData[ID].stunts[9], playerData[ID].stunts[10],playerData[ID].stunts[11], playerData[ID].stunts[12], playerData[ID].stunts[13], playerData[ID].stunts[14], playerData[ID].stunts[15], playerData[ID].stunts[16], playerData[ID].stunts[17], playerData[ID].stunts[18], playerData[ID].stunts[19], Name ));
    }

    function onPickupPickedUp(player, pickup)
    {   
        // Completed stunt is array value + 1 as array is between 0-19 while we want our stunts to be numerated as 1-20
        local a = 0;
        local stuntCompleted = 0;
        for(a = 0; a < jumps.len(); ++a)
        {
            if(jumps[a] && pickup.ID == jumps[a]) {
                if(!playerData[player.ID].stunts[a]) {
                    if(player.Vehicle && (GetVehicleType(player.Vehicle.Model) == "Land Vehicle" || GetVehicleType(player.Vehicle.Model) == "Bike"))
                    {
                        playerData[player.ID].stuntsCompleted++;

                        local stuntsCompleted = playerData[player.ID].stuntsCompleted;
                        local bonus = stuntsCompleted * 500;
                        player.IncCash(bonus);
                        if(stuntsCompleted == 5)
                        {
                            ::Announce("Completed 5 stunt jumps! $5000 Reward!", player, 0);
                            player.IncCash(5000);
                        }
                        if(stuntsCompleted == 10)
                        {
                            ::Announce("Completed 10 stunt jumps! You can now use the TV in properties!", player, 0);
                        }
                        if(stuntsCompleted == 20)
                        {
                            ::Announce("Completed every stunt jump! You will now spawn with 120HP!", player, 0);
                        }

                        ::Announce("UNIQUE STUNT JUMP BONUS!", player, 7);
                        ::Announce("Completed stunts: " + playerData[player.ID].stuntsCompleted + " of 20", player, 8)
                        ::MessagePlayer(COLOR_PINK + "Bonus cash: " + COLOR_WHITE + bonus, player);
                        playerData[player.ID].stunts[a] = 1;
                        UpdateStunts(player);
                    }
                }


                else ::Announce("STUNT JUMP ALREADY COMPLETED!", player, 7);
            }
        }
    }

}


stuntjumps <- stuntJumps();