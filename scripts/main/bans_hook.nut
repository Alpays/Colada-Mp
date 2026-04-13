/*

File: bans_hook.nut

Description: bans.nut should be loaded so it's functions can be used through the other scripts
this file is loaded as a "module" and it hooks bans.onScriptLoad() to onScriptLoad() function

*/

function onScriptLoad()
{
    bans.onScriptLoad();
}

function onScriptUnload()
{
    bans.onScriptUnload();
}