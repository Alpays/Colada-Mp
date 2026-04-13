/*

File: race.nut

Description: SQL Based racing mode (with checkpoints!)

*/


racePickup <- null;


class Race
{
    isStarted = false;
    goingToStart = false;

    countDownTimer = null;
    startTimer = null;

    trackName = "Unknown";
    trackId = 0;
    trackAuthor = "Unknown";

    startingPos = Vector(0,0,0);
    startingAngle = 0;

    vehicle = 0;
    weather = 0;
    hour = 0;

    best = "-";
    bestTime = 9999;
    startTime = 0;
    finishTime = 0;

    elapsedTimer = null;


    // Players will be teleported to offset + race id world to race.
    raceWorldOffset = 200;

    function convertRaceTime(rtime)
    {
        local mincount = 0;
        mincount = rtime / 60;
        rtime -= mincount * 60;

        if(!mincount) return rtime + " seconds!";
        else return mincount + " minutes and " + rtime + " seconds!";
    }
    function startCountdown()
    {
        AnnRaceCD(3);
        NewTimer("AnnRaceCD", 1 * 1000, 1, 2);
        NewTimer("AnnRaceCD", 2 * 1000, 1, 1);
        NewTimer("AnnRaceCD", 3 * 1000, 1, 0);
    }
    function showElapsedTime()
    {
        for(local i = 0; i < ::GetMaxPlayers(); ++i)
        {
            if(::FindPlayer(i) && playerData[i].inRace)
            {
                if(isStarted) {
                    local sec = time() - startTime;
                    local min = sec / 60;
                    sec -= min * 60;
                    ::Announce("~g~" + format("%02d", min) + ":" + format("%02d",sec), ::FindPlayer(i), 5);
                }
            }
        }
    }
    function startRace()
    {
        ::Message(COLOR_PINK + "Race has been started!");
        isStarted = true;
        startTime = time();
        elapsedTimer = ::NewTimer("showElapsedTime", 1 * 1000, 0)

        for(local i = 0; i < ::GetMaxPlayers(); ++i)
        {
            if(GetPlayer(i) && playerData[i].inRace)
            {
                local player = GetPlayer(i);
                // First checkpoint.
                local q = ::QuerySQL(raceDb, "SELECT * FROM checkpoints WHERE raceid='"+trackId+"' and cpid='"+1+"'");
                if(q) {
                    local x = ::GetSQLColumnData(q, 2);
                    local y = ::GetSQLColumnData(q, 3);
                    local z = ::GetSQLColumnData(q, 4);
                    playerData[player.ID].currentCp = ::CreateCheckpoint(player, player.UniqueWorld, false, Vector(x,y,z), ARGB(255, 212,15,212), 6);
                    playerData[player.ID].currentCpMarker = ::CreateMarker(player.UniqueWorld, Vector(x,y,z), 5, RGBA(221,34,221,255), 2);
                    ::FreeSQLQuery(q);
                }
                player.Frozen = false;
            }
        }
    }
    function getRacerCount()
    {
        local playerCountInRace = 0;
        for(local i = 0; i < ::GetMaxPlayers(); ++i) {
            if(GetPlayer(i) && playerData[i].inRace) {
                ++playerCountInRace;
            }
        }        
        return playerCountInRace;
    }
    function cancelRace(reason) 
    {
        isStarted = false;
        goingToStart = false;
        for(local i = 0; i < 100; ++i) {
            if(GetPlayer(i) && playerData[i].inRace)
            {
                playerData[i].inRace = false;
                playerData[i].racingVehicle.Delete();
                if(playerData[i].currentCp) playerData[i].currentCp.Remove();
                if(playerData[i].currentCpMarker) ::DestroyMarker(playerData[i].currentCpMarker);
                if(playerData[i].nextCpMarker) ::DestroyMarker(playerData[i].nextCpMarker);
                GetPlayer(i).World = 1;
                GetPlayer(i).Frozen = false;
            }
        }
        ::Message(COLOR_PINK + "Race has been cancelled. Reason: " + reason);
        if(startTimer) startTimer.Delete();
        if(countDownTimer) countDownTimer.Delete();
    }
    function onPlayerSpawn(player)
    {
        if(playerData[player.ID].inRace)
        {
            if(playerData[player.ID].racingVehicle.Health > 0) {
                playerData[player.ID].racingVehicle.Pos = playerData[player.ID].currentCp.Pos;
                player.Vehicle = playerData[player.ID].racingVehicle;
            }
            else {
                playerData[player.ID].racingVehicle = ::CreateVehicle( vehicle, raceWorldOffset + trackId, playerData[player.ID].currentCp.Pos, startingAngle, 7, 1);
                playerData[player.ID].racingVehicle.SingleUse = true;
                player.Vehicle = playerData[player.ID].racingVehicle;
            }
        }
    }
    function onPickupPickedUp(player, pickup)
    {
        if(pickup.ID == racePickup.ID)
        {
            if(!isStarted && !goingToStart) {
                local q, raceid, racename, raceauthor;
                local racesFound = 0;
                local q = ::QuerySQL(raceDb, "SELECT * FROM races");
                if(q) {
                    while(::GetSQLColumnData(q, 0)) {
                        racesFound++;
                        raceid =     ::GetSQLColumnData(q, 0)
                        racename =   ::GetSQLColumnData(q, 1)
                        raceauthor = ::GetSQLColumnData(q, 2)   
                        ::GetSQLNextRow(q);
                        ::MessagePlayer(COLOR_ORANGE + "Race ID: " + COLOR_WHITE + raceid + COLOR_ORANGE + " Name: " + COLOR_WHITE + racename + COLOR_ORANGE + " Author: " + COLOR_WHITE + raceauthor, player)                    
                    }
                    ::FreeSQLQuery(q);
                }
                if(racesFound == 0) {
                    ::MessagePlayer(COLOR_RED + "No races available to start!", player);
                }
            }
        }
    }
    function onCheckpointEntered(player, cp)
    {
        if(playerData[player.ID].inRace) {
            playerData[player.ID].cpTaken++;
            playerData[player.ID].currentCp.Remove();
            ::DestroyMarker(playerData[player.ID].currentCpMarker);
            if(playerData[player.ID].nextCpMarker) ::DestroyMarker(playerData[player.ID].nextCpMarker);

            local q = ::QuerySQL(raceDb, "SELECT * FROM checkpoints WHERE raceid='"+trackId+"' AND cpid='"+(playerData[player.ID].cpTaken + 1)+"'")
            if(q) {
                local x = ::GetSQLColumnData(q, 2);
                local y = ::GetSQLColumnData(q, 3);
                local z = ::GetSQLColumnData(q, 4);
                playerData[player.ID].currentCp = ::CreateCheckpoint(player, player.UniqueWorld, false, Vector(x,y,z), ARGB(255, 212,15,212), 6);
                playerData[player.ID].currentCpMarker = ::CreateMarker(player.UniqueWorld, Vector(x,y,z), 5, RGBA(221,34,221,255), 0);

                ::FreeSQLQuery(q);

                q = ::QuerySQL(raceDb, "SELECT * FROM checkpoints WHERE raceid='"+trackId+"' AND cpid='"+(playerData[player.ID].cpTaken + 2)+"'");
                if(q) {
                    local x = ::GetSQLColumnData(q, 2);
                    local y = ::GetSQLColumnData(q, 3);
                    local z = ::GetSQLColumnData(q, 4);
                    playerData[player.ID].nextCpMarker = ::CreateMarker(player.UniqueWorld, Vector(x,y,z), 5, RGBA(91,23,88,200), 0);                    
                    ::FreeSQLQuery(q);
                }
            }
            else { // Race has been completed.
                local raceReward = 1000 * getRacerCount();
                ::Message(COLOR_ORANGE + "Race ended! Winner: " + COLOR_WHITE + player.Name + COLOR_ORANGE + " Reward: " + COLOR_WHITE + "$" + raceReward);
                isStarted = goingToStart = false;
                for(local i = 0; i < ::GetMaxPlayers(); ++i) {
                    if(GetPlayer(i) && playerData[i].inRace) {
                        local player = GetPlayer(i);
                        player.World = 1;
                        player.IncCash(raceReward);
                        playerData[i].inRace = false;
                        playerData[i].cpTaken = 0;
                        if(playerData[player.ID].racingVehicle) playerData[player.ID].racingVehicle.Delete();
                        if(playerData[player.ID].currentCp) playerData[player.ID].currentCp.Remove();
                        if(playerData[player.ID].currentCpMarker) ::DestroyMarker(playerData[player.ID].currentCpMarker);
                        if(playerData[player.ID].nextCpMarker) ::DestroyMarker(playerData[player.ID].nextCpMarker);
                    }
                }
                finishTime = time() - startTime;
                if(finishTime < bestTime )
                {
                    ::Message(COLOR_PINK + "A New record has been set by " + COLOR_WHITE + player.Name + COLOR_PINK + " completing the race in " + convertRaceTime(finishTime));
                    ::QuerySQL(raceDb, format("UPDATE races SET best='%s', besttime='%d' WHERE id='%d'", player.Name, finishTime, trackId));
                }
            }
        }
    }
    function onPlayerCommand(player, cmd, text)
    {
        switch(cmd.tolower())
        {
            case "startrace":
            {
                if(text)
                {
                    if(::IsNum(text))
                    {
                        text = text.tointeger();
                        local q = ::QuerySQL(raceDb, "SELECT * FROM races WHERE id='"+text+"'");
                        if(q) {
                            if(!isStarted && !goingToStart)
                            {
                                trackId    =    ::GetSQLColumnData(q, 0);
                                trackName  =    ::GetSQLColumnData(q, 1);
                                trackAuthor =   ::GetSQLColumnData(q, 2);
                                startingPos.x = ::GetSQLColumnData(q, 3);
                                startingPos.y = ::GetSQLColumnData(q, 4);
                                startingPos.z = ::GetSQLColumnData(q, 5);
                                startingAngle = ::GetSQLColumnData(q, 6);
                                vehicle =       ::GetSQLColumnData(q, 7);
                                best =          ::GetSQLColumnData(q, 8);
                                bestTime =      ::GetSQLColumnData(q, 9);
                                goingToStart = true;
                                countDownTimer = ::NewTimer("cdtimer", 17 * 1000, 1);
                                startTimer = ::NewTimer("startrace", 20 * 1000, 1);
                                ::Message(COLOR_PINK + "A race has been started by " + COLOR_WHITE + player.Name + COLOR_PINK + " Track name: " + COLOR_WHITE + trackName + COLOR_PINK + " Author: " + COLOR_WHITE + trackAuthor + COLOR_PINK + " use /joinrace to participate it!");
                                if(best != "-") {
                                    ::Message(COLOR_PINK + "Record time has been set by " + COLOR_WHITE + best + COLOR_PINK + " in " + convertRaceTime(bestTime));
                                }
                            }
                            else ::MessagePlayer(COLOR_RED + "A race is already in the progress!", player);
                        }
                        else ::MessagePlayer(COLOR_RED + "No race with such id.", player);
                    }
                    else ::MessagePlayer(COLOR_RED + "Correct usage: /startrace <race id> -- You can check the race list via /listraces.", player);
                }
                else ::MessagePlayer(COLOR_RED + "Correct usage: /startrace <race id> -- You can check the race list via /listraces.", player);
                break;
            }
            case "joinrace":
            {
                if(!isStarted)
                {
                    if(goingToStart)
                    {
                        if(player.Health >= 75)
                        {
                            if(!playerData[player.ID].inRace) {
                                playerData[player.ID].racingVehicle = ::CreateVehicle( vehicle, raceWorldOffset + trackId, startingPos, startingAngle, 7, 1);
                                playerData[player.ID].racingVehicle.SingleUse = true;
                                player.World = (raceWorldOffset + trackId);
                                player.Vehicle = ::FindVehicle(playerData[player.ID].racingVehicle.ID);
                                player.Vehicle.IsGhost = true;
                                if(GetVehicleType(player.Vehicle.Model) != "Bike") player.Vehicle.Locked = true;
                                player.Vehicle.Immunity = 255;
                                playerData[player.ID].inRace = true;
                                playerData[player.ID].propEnter = null;
                                player.Frozen = true;
                                player.Vehicle.Radio = 10;
                                ::Message(COLOR_BLUE + player.Name + COLOR_WHITE + " has joined the race.");
                            }
                            else ::MessagePlayer(COLOR_RED + "You are already in the race!", player);
                        }
                        else ::MessagePlayer(COLOR_RED + "You need +75 hp to join the race!", player);
                    }
                    else ::MessagePlayer(COLOR_RED + "No started race in progress. You can start one from Sunshine Autos.", player);
                }
                else ::MessagePlayer(COLOR_RED + "The race is already started.", player);
                break;
            }
            case "listraces":
            {
                local q, raceid, racename, raceauthor;
                local racesFound = 0;
                local q = ::QuerySQL(raceDb, "SELECT * FROM races");
                if(q) {
                    while(::GetSQLColumnData(q, 0)) {
                        racesFound++;
                        raceid =     ::GetSQLColumnData(q, 0);
                        racename =   ::GetSQLColumnData(q, 1);
                        raceauthor = ::GetSQLColumnData(q, 2);  
                        ::GetSQLNextRow(q);
                        ::MessagePlayer(COLOR_ORANGE + "Race ID: " + COLOR_WHITE + raceid + COLOR_ORANGE + " Name: " + COLOR_WHITE + racename + COLOR_ORANGE + " Author: " + COLOR_WHITE + raceauthor, player)                    
                    }
                    ::FreeSQLQuery(q);
                }
                if(racesFound == 0) {
                    ::MessagePlayer(COLOR_RED + "No races available to start!", player);
                }
                break;
            }
        }
    }
}

race <- Race();

function cdtimer(){ 
    if(race.getRacerCount() >= 1) { 
        race.startCountdown();
    }
    else race.cancelRace("Not enough players.");
}
function startrace() {
    if(race.getRacerCount() >= 1) { 
        race.startRace();
    }
    else race.cancelRace("Not enough players.");
}

function showElapsedTime()
{
    race.showElapsedTime();
}

function AnnRaceCD(state)
{
    for(local i = 0; i < 100; ++i)
    {
        if(GetPlayer(i) && playerData[i].inRace)
        {
            switch(state)
            {
                case 3:
                    ::Announce("~o~3 ~t~2 1", GetPlayer(i), 5);
                    break;
                case 2:
                    ::Announce("~t~3 ~o~2 ~t~1", GetPlayer(i), 5);
                    break;
                case 1:
                    ::Announce("~t~3 ~t~2 ~o~1", GetPlayer(i), 5);
                    break;
                case 0:
                    ::Announce("~t~GO GO GO!", GetPlayer(i), 5);
                    GetPlayer(i).SpawnSound();
            }
        }
    }
}

function loadRace()
{
    racePickup = ::CreatePickup(367, Vector(-969.07, -827, 6.7));

    raceDb <- ConnectSQL("races.db");

    ::QuerySQL(raceDb, "CREATE TABLE IF NOT EXISTS races(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, author TEXT, startx FLOAT, starty FLOAT, startz FLOAT, startangle FLOAT, vehicle INTEGER, best TEXT, besttime INTEGER)");
    ::QuerySQL(raceDb, "CREATE TABLE IF NOT EXISTS checkpoints(raceid INTEGER, cpid INTEGER, x FLOAT, y FLOAT, z FLOAT)");
}