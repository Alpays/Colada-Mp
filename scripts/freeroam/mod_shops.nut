/*

File: mod_shops.nut 

Description: Adds mod shops at Pay n Spray locations that allows players to modify their vehicles.

Backspace -- exists the mod shop
Enter -- paints car first color
Right shift -- paints car secondary color
X -- repairs the vehicle
Left arrow key -- goes back to the previous car color id 
Right arrow key -- goes to the next car color id
Up key -- goes back to the previous secondary car color id
Down key -- goes to the next secondary color id
C -- Cars only drift handling

*/


modShopCp <- array(4, null);

exitModShopkey <- BindKey(true, 0x08, 0, 0) // Backspace 
purchaseColorKey <- BindKey(true, 0x0D, 0, 0) // Enter 
purchaseSecondaryColorKey <- BindKey(true, 0xA1, 0, 0) // Right shift 
fixVehicleKey <- BindKey(true, 0x58, 0, 0) // X 
buyDriftHandling <- BindKey(true, 0x43, 0, 0) // C
previousColor <- BindKey(true, 0x25, 0, 0) // Left arrow key 
nextColor <- BindKey(true, 0x27, 0, 0) // Right arrow key 
previousSecondColor <- BindKey(true, 0x26, 0, 0) // Up key 
nextSecondColor <- BindKey(true, 0x28, 0, 0) // Down key 
orangeLightKey <- BindKey(true, 0x56, 0,0) // V Key

modShops <-
[ 
    [Vector(-879.133, -114.32, 11.2), Vector(-868, -120, 11.08)], // Little Haiti Pay n Spray
    [Vector(-2.133, -1257.32, 10.4), Vector(-15, -1257, 10)], // Ocean Beach Pay n Spray
    [Vector(-906.133, -1255.32, 11.7), Vector(-913, -1271, 11.7)], // Vice Port Pay n Spray
    [Vector(321.0,432.0,10.71), Vector(331, 428, 11.35)], // Vice Point Pay n Spray
]

function onScriptLoad() {
    HideMapObject( 1573, -874.696, -116.696, 11.9875 ); // Little Haiti Pay n Spray door
    HideMapObject( 3013, -7.80468, -1257.64, 10.8187 ); // Ocean Beach Pay n Spray door
    HideMapObject( 828, -910.002, -1264.71, 12.4923 ); // Vice Port Pay n Spray door
    HideMapObject( 4145, 325.083, 431.137, 11.5872 ); // Vice Point Pay n Spray door

    loadModshops();

}

function loadModshops() {
    for(local i = 0; i < modShops.len(); ++i)
    {
        modShopCp[i] = CreateCheckpoint( null, 0, true, modShops[i][0], ARGB(255, 125, 255, 255), 2).ID;
    }
}

function onCheckpointEntered( player, cp ) {
    for(local i = 0; i < modShopCp.len(); ++i) {
        if(cp.ID == modShopCp[i]) {
            if(player.Vehicle) {
                if(player.Vehicle.Health >= 250) {
                    if(player.Health >= 50)
                    {
                        if(getVehiclePlayerCount(player.Vehicle) > 1 )
                        {
                            MessagePlayer(COLOR_RED + "You can't enter mod shop when there are passengers!", player);
                            return;
                        }
                        playerData[player.ID].modshopEnter = modShops[i][1];
                        playerData[player.ID].carColor = player.Vehicle.Colour1;
                        playerData[player.ID].carSecondaryColor = player.Vehicle.Colour2;
                        onPlayerEnterModShop(player, player.Vehicle);      
                    }
                    else Announce("~o~YOU NEED MORE THAN 50 HP TO ENTER HERE, NO ROOM FOR DEATH EVADERZ.", player, 0);
                }
                else Announce("~o~YOU CAN'T ENTER HERE WHEN YOUR VEHICLE IS ON FIRE!", player, 0);
            }
            else Announce("~o~YOU NEED A VEHICLE TO ENTER HERE!", player, 0);
            break;
        }
    }
}

function onPlayerEnterModShop(player, vehicle) {
    playerData[player.ID].modshop = true;

    player.World = player.Vehicle.World = player.UniqueWorld;

    vehicle.Pos = Vector(-1007, -848, 7.365);
    vehicle.Angle = Quaternion(0.0, 0.0, 0.01, 0.99);
    vehicle.BonnetOpen = true;
    player.Frozen = true;
    
    player.Vehicle = vehicle;

    player.SetCameraPos(Vector(-1012, -842, 7.63), Vector(-1008.90, -844.90, 7.60), 0);

    Announce("~g~Welcome to Vice City Modshop!", player, 0);
    MessagePlayer(COLOR_BLUE + "Press X to fix your vehicle for $1000", player);
    MessagePlayer(COLOR_BLUE + "Use left/right arrow keys to change your vehicle color", player);
    MessagePlayer(COLOR_BLUE + "Use up/down arrow keys to change your vehicle secondary color", player);
    MessagePlayer(COLOR_BLUE + "Press enter to confirm the vehicle color you chose. ($1500)", player);
    MessagePlayer(COLOR_BLUE + "Press rshift to confirm the secondary vehicle color you chose. ($750)", player);
    MessagePlayer(COLOR_BLUE + "Press C to buy drift handling (Cars only) ($750)", player);
    MessagePlayer(COLOR_BLUE + "Press V to buy orange lights (Cars only) ($500)", player);
}

function onKeyUp(player, key) {
    if(playerData[player.ID].modshop) {
        if(key == exitModShopkey) {
            local veh = player.Vehicle;
            player.Frozen = false;
            player.World = player.Vehicle.World = 1;
            veh.Pos = playerData[player.ID].modshopEnter;
            player.Vehicle = veh;
            player.RestoreCamera();
            playerData[player.ID].modshop = false;

            player.Vehicle.Colour1 = playerData[player.ID].carColor;
            player.Vehicle.Colour2 = playerData[player.ID].carSecondaryColor;

            player.Vehicle.BonnetOpen = false;
        }
        if (key == fixVehicleKey) {
            if(player.Cash >= 1000) {
                if(player.Vehicle.Health < 1000) {
                    player.DecCash(1000);
                    player.Vehicle.Fix();
                    Announce("~g~Vehicle has been fixed.", player, 0);
                    player.PickupSound();
                }
                else Announce("~o~Your vehicle is not damaged!", player, 0);
            }
            else Announce("~o~You don't have enough money for fixing your vehicle!", player, 0);
        }
        if (key == previousColor) {
            if(player.Vehicle.Colour1 >= 1) player.Vehicle.Colour1 -= 1;
            else player.Vehicle.Colour1 = 105;
            PlaySound( player.UniqueWorld , 361 , player.Pos );
                    
        }
        if (key == nextColor) {
            if(player.Vehicle.Colour1 < 105) player.Vehicle.Colour1 += 1;
            else player.Vehicle.Colour1 = 1;
            PlaySound( player.UniqueWorld , 362 , player.Pos );
        }
        if (key == previousSecondColor) {
            if(player.Vehicle.Colour2 >= 1) player.Vehicle.Colour2 -= 1;
            else player.Vehicle.Colour2 = 105;
            PlaySound( player.UniqueWorld , 361 , player.Pos );
                    
        }
        if (key == nextSecondColor) {
            if(player.Vehicle.Colour2 < 105) player.Vehicle.Colour2 += 1;
            else player.Vehicle.Colour2 = 1;
            PlaySound( player.UniqueWorld , 362 , player.Pos );
        }
        if (key == purchaseColorKey) {
            if(player.Vehicle.Colour1 != playerData[player.ID].carColor) {
                if(player.Cash >= 1500) {
                    playerData[player.ID].carColor = player.Vehicle.Colour1;
                    Announce("~g~You have modified your vehicle's main colour!", player, 0);
                    player.PickupSound();
                    player.DecCash(1500);
                }
                else Announce("~o~You don't have enough money for buying this color!", player, 0);
            }
            else Announce("~o~Your vehicle is already set to this colour!", player, 0);
        }
        if (key == purchaseSecondaryColorKey) {
            if(player.Vehicle.Colour2 != playerData[player.ID].carSecondaryColor) {
                if(player.Cash >= 750) {
                    playerData[player.ID].carSecondaryColor = player.Vehicle.Colour2;
                    Announce("~g~You have modified your vehicle's secondary colour!", player, 0);
                    player.PickupSound();
                    player.DecCash(750);  
                }           
                else Announce("~o~You don't have enough money for buying this color!", player, 0);   
            }
            else Announce("~o~Your vehicle's second colour is already set to this!", player, 0);   
        }
        if (key == buyDriftHandling)
        {
            if(player.Cash >= 750)
            {
                if(GetVehicleType(player.Vehicle.Model) == "Land Vehicle") 
                {
                    Announce("~g~You have modified your car's drift handling!", player, 0);
                    player.DecCash(750);
                    local vehicle = player.Vehicle;
                    // [Ro]Sebastian's art.
                    vehicle.SetHandlingData( 6, 0 ); // centre of mass Y
                    vehicle.SetHandlingData( 7, -0.2 ); // centre of mass Z
                    vehicle.SetHandlingData( 9, 0.5 ); // Traction Multiplier
                    vehicle.SetHandlingData( 11, 0.6 ); // Traction Bias
                    vehicle.SetHandlingData( 15, 52 ); // Drive Type = 4 wheels driving
                    vehicle.SetHandlingData( 14, 30 ); // Acceleration
                    vehicle.SetHandlingData( 17, 40 ); // Brake Deceleration
                    vehicle.SetHandlingData( 19, 40 ); // Steering Lock
                    player.PickupSound();
                }
                else Announce("~o~This option is for cars only!", player, 0);
            }
            else Announce("~o~You don't have enough money for modifying your car's drift handling!", player, 0);
        }
        if (key == orangeLightKey)
        {
            if(player.Cash >= 500)
            {
                if(GetVehicleType(player.Vehicle.Model) == "Land Vehicle") 
                {
                    player.DecCash(500);
                    local vehicle = player.Vehicle;
                    vehicle.SetHandlingData(29, -2); //orange front
                    vehicle.SetHandlingData(30, -6); //orange rear
                    player.PickupSound();
                }           
                else Announce("~o~This option is for cars only!", player, 0);     
            }
            else Announce("~o~You don't have enough money for modifying your car's lights!", player, 0);
        }
    }
}
