/*

File: sea_sparrow.nut

Description: Adds a sea sparrow that spawns at random locations.

*/

seaSparrow <- null;

seaSparrowSpawns <-
[
    [Vector(-705.74, 801, 23.91)],
    [Vector(-1090, -231, 22.96)],
    [Vector(-1174, -715, 22.70)],
    [Vector(-687, -1567, 12.43)],
    [Vector(-68.58, -1609, 12.03)],
    [Vector(279, -685, 9.9)],
    [Vector(-70, 1012, 10.1)]
]

function changeSeaSparrowLoc() {
    local r = random(0,(seaSparrowSpawns.len() - 1));
    local pos = seaSparrowSpawns[r][0];
    if(seaSparrow != null) {
        seaSparrow.SpawnPos = pos;
    }
}

function onScriptLoad() {
    local r = random(0,(seaSparrowSpawns.len() - 1));
    local pos = seaSparrowSpawns[r][0];
    seaSparrow = CreateVehicle( VEH_SEASPARROW, pos, 0.0, 1, 1 );
}

function onSparrowFrenzyEnd(player)
{
    Announce("Sparrow kill frenzy over", player, 6);
    Announce("Kills: " + playerData[player.ID].sparrowKills, player, 8);
    playerData[player.ID].sparrowKills = 0;
    local str = Stream();
    str.StartWrite();
    str.WriteByte(STREAM_SPARROWEXIT);
    str.SendStream(player);  
}

function onPlayerKill(killer, player, reason, bodypart) {
    if(killer.Vehicle) {
        if(killer.Vehicle.Model == VEH_SEASPARROW) {
            playerData[killer.ID].sparrowKills++;
            if(playerData[killer.ID].sparrowKills % 5 == 0)
            {
                local killBonus = playerData[killer.ID].sparrowKills * 100;
                Announce("" + playerData[killer.ID].sparrowKills + " in a row bonus! $" + killBonus, killer, 6);
                killer.IncCash(killBonus);
                killer.SpawnSound();
            }
            local str = Stream();
            str.StartWrite();
            str.WriteByte(STREAM_SPARROWKILL);
            str.WriteString("sea sparrow kills: " + playerData[killer.ID].sparrowKills);
            str.SendStream(killer);
        }
        if(player.Vehicle && player.Vehicle.Model == VEH_SEASPARROW)
        {
            onSparrowFrenzyEnd(player);    
        }
    }
}

function onVehicleExplode(vehicle) {
    if(vehicle.Model == VEH_SEASPARROW) {
        changeSeaSparrowLoc();
    }
}

function onPlayerDeath(player, reason) {
    if(player.Vehicle && player.vehicle.Model == VEH_SEASPARROW)
    {
        onSparrowFrenzyEnd(player);
    }
}

function onPlayerEnterVehicle(player, vehicle, door) {
    if(vehicle.Model == VEH_SEASPARROW) {
        if(door == 0) // Driver seat.
        {  
            Message(COLOR_BLUE + player.Name + COLOR_WHITE + " has collected the Sea Sparrow!")
            Announce("SPARROW KILL FRENZY!", player, 6);
            Announce("~g~Get as much as kills you can with the Sea Sparrow! (Right click to use the machine gun)", player, 1);
            player.PickupSound();
        }
    }
}

function onPlayerExitVehicle(player, vehicle)
{
    if(vehicle.Model == VEH_SEASPARROW) {
        onSparrowFrenzyEnd(player);
    }
}