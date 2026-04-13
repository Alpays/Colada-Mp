/*

File: bleed.nut

Description: New 0.4.7.1 feature to make player bleed when hp is low, just like in the singleplayer!

*/

function onPlayerHealthChange(player, lastHP, newHP)
{
	if(newHP <= 10) player.Bleeding = true;
    else if(lastHP <= 10 && newHP > 10) player.Bleeding = false;
}