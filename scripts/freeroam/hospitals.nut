/*

File: hospitals.nut

Description: Adds a command to heal player at hospitals.

*/

// Hospitals

oceanViewHospital <- [-116.0, -913.0,  -205.0, -944.0,  -185.0, -1033.0,  -96.0, -1009.0];
shadyPalmsHospital <- [434.0, 699.0,  497.0, 693.0,  499.0, 745.0,  435.0, 748.0];
schumanHospital <- [-847.0, 1158.0,  -766.0, 1162.0,  -766.0, 1102.0, -842.0, 1102.0];
westHavenHospital <- [860.0, -489.0,  -884.0, -485.0,  -884.0, -451.0,  -874.0, -450.0];

// Dispensaries & Ryton Aide

rytonAide <- [-841.0, -77.0,  -870.0, -86.0,  -847.0, -70.0]
downtownDispensary <- [-828.0, 747.0,  -829.0, 737.0,  -845.0, 739.0,  -845.0, 748.0];
vicePointDispensary <- [376.0, 760.0,  387.0, 760.0,  386.0, 748.0,  378.0,  749.0];

healingPoints <- [oceanViewHospital, shadyPalmsHospital, schumanHospital, westHavenHospital, rytonAide, downtownDispensary, vicePointDispensary];


function onPlayerCommand(player, cmd, text)
{ 
    switch(cmd.tolower())
    {
        case "heal":
        {
            local x = player.Pos.x;
            local y = player.Pos.y;
            local inHospital = 0;
            for(local i = 0; i < healingPoints.len(); ++i)
            {
                if(InPoly(x, y, healingPoints[i]) == true)
                {
                    inHospital = 1;
                    break;
                }
            }
            if(inHospital)
            {
                if(player.Health >= 100) 
                {
                    MessagePlayer(COLOR_RED + "Your health is already full!", player);
                    return;
                }
                if(playerData[player.ID].healTimer)
                {
                    MessagePlayer(COLOR_RED + "You're already being healed!", player);
                    return;
                }
                playerData[player.ID].healPos = player.Pos;
                playerData[player.ID].healTimer = NewTimer("healPlayer", 3 * 1000, 1, player.ID);
                MessagePlayer(COLOR_GREEN + "You will be healed in 3 seconds. don't move", player);
            }
            else MessagePlayer(COLOR_RED + "You have to be in a hospital or dispensary to use this command!", player);
            break;
        }
    }
    
}