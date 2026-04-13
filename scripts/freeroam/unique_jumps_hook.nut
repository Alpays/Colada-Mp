/*

File: unique_jumps_hook.nut

Description: Events to hook Unique Stunt Jumps system.

*/


function onScriptLoad()
{
    stuntjumps.onScriptLoad();
}

function onScriptUnload()
{
    stuntjumps.onScriptUnload();
}

function onPickupPickedUp(player, pickup)
{
    stuntjumps.onPickupPickedUp(player, pickup);
}

function onPlayerSpawn(player)
{
    if(playerData[player.ID].stuntsCompleted == 20)
    {
        player.Health = 120;
    }
}