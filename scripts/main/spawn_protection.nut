function onPlayerSpawn(player)
{
    if(!playerData[player.ID].inRace || !playerData[player.ID].racingVehicle) {
        player.Immunity = 255;
        playerData[player.ID].spawnTimer = NewTimer("EndPlayerSpawnProtection", 3 * 1000, 1, player.ID);
    }
}