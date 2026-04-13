/*

File: disable_fpv.nut

Description: Prevents players to use First Person View (FPV) on M4, M60 and Ruger.

*/

function onPlayerActionChange(player, oldAction, newAction) {
    if (newAction == 12) {
        if(getWeaponType(player.Weapon) == "Rifle" || player.Weapon == WEP_M60)
        {
            Announce("~g~FPV is disabled in this server!", player, 1);
            player.Slot = 0;
        }
    }
}
