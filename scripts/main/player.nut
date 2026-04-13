/*

File: player.nut

Description: Player class to store variables that are defined in the script.

*/

class Player {
    // accounts.nut
    kills = 0;
    deaths = 0;
    topSpree = 0;
    adminLevel = 0;
    headshots = 0;

    registered = false;
    logged = false;

    /* car1 and car2 values store the vehicle model, currentCar stores ID of the current car spawned by the player*/
    car1 = 0;
    car2 = 0;
    currentCar = null;
    lastSpawnTime = null;

    // hospitals.nut

    healPos = null;
    healTimer = null;

    // properties.nut
    propEnter = null;
    worldTimer = null;

    // ammu_nation.nut
    buymode = false;

    // mod_shops.nut
    modshop = false;
    modshopEnter = null;
    carColor = null;
    carSecondaryColor = null;

    // spree.nut
    spree = 0;
    // spawnweps.nut
    spawnweps = null;

    // diepos.nut
    diePos = null;
    spawnOnDeath = true;

    // sea_sparrow.nut
    sparrowKills = 0;

    // unique_jumps.nut
    stuntsCompleted = 0;
    stunts = null; 

    // race.nut
    inRace = false;
    racingVehicle = null;

    cpTaken = 0;
    currentCp = null;
    currentCpMarker = null;
    nextCpMarker = null;

    // limits.nut
    fps_warn = 0;
    ping_warn = 0;
    jitter_warn = 0;
    recent_ping = 0;

    // player_colors.nut
    colour = RGB(255, 125, 255);

    // vehicle_controls.nut
    lastFlip = 0;

    // spawn_protection.nut
    spawnTimer = null;

    // basic_commands.nut
    confirm = false; // /resetstats confirmation.

    // first_spawn.nut
    firstSpawn = true;

    // laser_sniper.nut
    laser = false;

    constructor() {
        stunts = array(20, 0);
        spawnweps = array(5, null);
        spawnweps.insert(0, WEP_M60); 
        spawnweps.insert(1, WEP_AK47); 
        spawnweps.insert(2, WEP_UZI); 
        spawnweps.insert(3, WEP_STUBBY); 
        spawnweps.insert(3, WEP_PYTHON); 
    }
}

playerData <- array ( GetMaxPlayers(), null );

function onPlayerJoin(player) {
    Message(COLOR_GREEN + player.Name + COLOR_WHITE + " has joined the game.");
    MessagePlayer(COLOR_GREEN + "Welcome to Vice City Kids Playground, " + player.Name + "!", player);
    playerData[player.ID] = Player();
    accounts.onPlayerJoin(player);
    bans.onPlayerJoin(player);
    snow.onPlayerJoin(player);
    onPlayerInfo(player);
    fileChecksum(player);
    Freeview.players[player.ID] = freeviewClass();
    playerData[player.ID].colour = RGB( random(50, 255), random(50, 255), random(50, 255) );
}

function onPlayerPart(player, reason) {
    switch(reason)
    {
        case 0: reason = "Timeout"; break;
        case 1: reason = "Disconnect"; break;
        case 2: reason = "Kicked"; break;
        case 3: reason = "Crashed"; break;
    }
    Message(COLOR_RED + player.Name + COLOR_WHITE + " has left the game. (" + reason + ")");
    accounts.onPlayerPart(player);
    Freeview.players[player.ID] = null;
    if(playerData[player.ID].worldTimer) playerData[player.ID].worldTimer.Delete();
    if(playerData[player.ID].currentCar) playerData[player.ID].currentCar.Delete();
    if(playerData[player.ID].healTimer)  playerData[player.ID].healTimer.Delete();
    if(playerData[player.ID].racingVehicle) playerData[player.ID].racingVehicle.Delete();
    if(playerData[player.ID].currentCpMarker) DestroyMarker(playerData[player.ID].currentCpMarker);
    if(playerData[player.ID].nextCpMarker) DestroyMarker(playerData[player.ID].nextCpMarker);
    if(playerData[player.ID].spawnTimer) playerData[player.ID].spawnTimer.Delete();
    if(race.isStarted && race.getRacerCount() <= 1) { 
        race.cancelRace("Not enough players.");
    }
    playerData[player.ID] = null;
    return 1;
}