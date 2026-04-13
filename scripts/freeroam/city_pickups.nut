/*

File: city_pickups.nut

Description: Free healing points and some weapons to spice up fighting areas. A variety for healing places other than /heal in hospitals&dispensary.

*/

healthPickups <-
[
    [Vector(-571, 782, 22.87)],
    [Vector(-901, 803, 11.49)],
    [Vector(-1042, 77.2, 11.6)],
    [Vector(424, 89.6, 11.3)],
    [Vector(450, 1101, 192.0)],
    [Vector(-1192, -448, 10.94)],
    [Vector(10, 1101, 16.58)],
    [Vector(-370, -603, 10.36)],
    [Vector(-1140, -601, 11.6)],
    [Vector(-1049, -664, 11.7)],
    [Vector(-834, 743, 11.28)],

    [Vector(-859, -353, 11.09)],
    [Vector(-1001, -1139, 14.86)],
    [Vector(100.2, -804, 10.46)],
    [Vector(-346, -542, 17.2)],
    [Vector(-1143, -285, 11.21)],

]

// Secret Weapons respawn time
// 1000 = 1 second, every weapon has 1 quantity.

MINIGUN_TIMER <- 1000 * 3;
RPG_TIMER <-     1000 * 30;
FLAME_TIMER <-   1000 * 20;
MOL_TIMER <-     1000 * 5;
TEAR_TIMER <-    1000 * 60 * 3;

secretWeps <-
[
    // Cuban v Haitian war (Molotovs Flaethrowers, and Teargases)
    [Vector(-1021, -75, 10.81), 272],
    [Vector(-1162, -380, 10.73), 272],
    [Vector(-1131, -372, 10.79), 271],
    [Vector(-1109, -472, 13.80), 272],
    [Vector(-1106, -602, 11.862), 288],
    [Vector(-1191, -413, 10.84), 272],
    [Vector(-1193, -317, 10.94), 271],
    [Vector(-1193, -505, 13.8), 272],

    // Phils Place (Minigun & RPG)
    [Vector(-1099, 330, 11.2), 290],
    [Vector(-1099, 333, 11.2), 287],

    // Vercetti Mansion (Minigun, Flame, RPG)
    [Vector(-351, -541, 17.28), 290],
    [Vector(-357, -541, 17.28), 288],
    [Vector(-364, -541, 17.28), 287],
]

function onScriptLoad()
{
    for(local i = 0; i < healthPickups.len(); ++i) {
        local loc = healthPickups[i][0];
        CreatePickup( 366, 1, 5, loc.x, loc.y, loc.z, 255, true );
    }    
    for(local i = 0; i < secretWeps.len(); ++i) {
        local loc = secretWeps[i][0];
        CreatePickup( secretWeps[i][1], 1, 1, loc.x, loc.y, loc.z, 255, true);
    }
}

function onPickupPickedUp(player, pickup)
{
    switch(pickup.Model)
    {
        case 271: pickup.Timer = TEAR_TIMER; break;
        case 272: pickup.Timer = MOL_TIMER; break;
        case 287: pickup.Timer = RPG_TIMER; break;
        case 288: pickup.Timer = FLAME_TIMER; break;
        case 290: pickup.Timer = MINIGUN_TIMER; break;
    }
}