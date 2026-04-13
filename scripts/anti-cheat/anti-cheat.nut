/*

Anti Cheat ban codes

0x01 = Armour hacking (No way to obtain armors in the server.)
0x02 = Illegal Weapon.
0x03 = Checksum Failed (Kicked out).
0x04 = Suspicious File name detected.
0x05 = Suspicious FPS value.
0x06 = Vehicle speed cheat
0x07 = Player speed cheat

Implemented Ones

Armour Anti-Cheat
Illegal Weapon Anti-Cheat
Suspicious FPS Anti Cheat

To:Do

File checksum
Suspicious file checksum

*/


function onPlayerArmourChange( player, lastArmour, newArmour )
{
    if(playerData[player.ID].adminLevel < 1)
    {
        bans.TempBan(player.Name, "Anti-Cheat", "4w", "Cheat Detected (0x01)");
    }
}

function onPlayerWeaponChange( player, oldWep, newWep )
{
    if(playerData[player.ID].adminLevel < 1)
    {
        if(newWep == 13 || newWep == 14) {
            bans.TempBan(player.Name, "Anti-Cheat", "4w", "Cheat Detected (0x02)");
        }
    }    
}
