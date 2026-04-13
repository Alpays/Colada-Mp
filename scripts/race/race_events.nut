/*

File: race_events.nut

Description: Race hook.

*/

function onScriptLoad()
{
    loadRace();
}

function onPickupPickedUp(player, pickup)
{
    race.onPickupPickedUp(player, pickup);
}

function onCheckpointEntered(player, cp)
{
    race.onCheckpointEntered(player, cp);
}

function onPlayerCommand(player, cmd, text)
{
    race.onPlayerCommand(player, cmd, text);
    onPlayerRaceEditorCommand(player, cmd, text);
}

function onPlayerSpawn(player)
{
    race.onPlayerSpawn(player);
}