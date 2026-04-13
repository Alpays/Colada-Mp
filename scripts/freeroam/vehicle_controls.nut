/*

File: vehicle_controls.nut

Description: Adds keys to give the player control to the vehicle they're driving.

*/

vehicleTaxiLights <- BindKey(true, 0x31, 0, 0)  // 1 Key
vehicleLights <- BindKey(true, 0x32, 0, 0)      // 2 Key
vehicleBoot <- BindKey(true, 0x33, 0, 0)        // 3 Key
flip <- BindKey(true, 0x58, 0, 0) // X Key

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower())
    {
        case "vehiclecontrols":
        case "vehcontrols":
        case "vc":
        {
            MessagePlayer(COLOR_YELLOW + "Vehicle controls: 1 - Toggle taxi light (Switch to fly mode if in Delly), 2 - Toggle vehicle light, 3 - Toggle vehicle boot, X - Flip your vehicle (Requires $500)", player);
            break;
        }
    }
}

function onKeyUp(player, key)
{
    if(key == vehicleTaxiLights) {
        if(player.Vehicle) player.Vehicle.TaxiLight = !player.Vehicle.TaxiLight;
        if(player.Vehicle && player.Vehicle.Model == 6440) {
            if( player.Vehicle.GetHandlingData( 28 ) == -2 )
            {
                player.Vehicle.SetHandlingData( 28, 10 );
                MessagePlayer(COLOR_PINK + "Switched back to driving mode.", player);
                return 0;
            }
            else if( player.Vehicle.GetHandlingData( 28 ) == 10 )
            {
                player.Vehicle.SetHandlingData( 28, -2 );
                MessagePlayer(COLOR_PINK + "Switched to heli mode! You have to stop your car for it to function", player);
                return 0;
            }
            else
            {
                player.Vehicle.SetHandlingData( 28, 10 );
                MessagePlayer(COLOR_PINK + "Switched back to driving mode.", player);
            }            
        }
    }
    if(key == vehicleLights) {
        if(player.Vehicle) player.Vehicle.Lights = !player.Vehicle.Lights;
    }
    if(key == vehicleBoot) {
        if(player.Vehicle) player.Vehicle.BonnetOpen = !player.Vehicle.IsBonnetOpen;
    }

    if(key == flip && !playerData[player.ID].modshop) {
        if(player.Vehicle)
        {
            if(player.Cash >= 500) {
                if(!playerData[player.ID].inRace) {
                    if(time() - playerData[player.ID].lastFlip >= 60)
                    {
                        playerData[player.ID].lastFlip = time();
                        MessagePlayer(COLOR_GRAY + "Flipped your vehicle for $500!", player);
                        player.DecCash(500);
                        local rot = player.Vehicle.Rotation;
                        player.Vehicle.Rotation = Quaternion( 0.0, 0.0, rot.z, rot.w );
                    }
                    else MessagePlayer(COLOR_RED + "You can flip your vehicle once a minute!", player);
                }
                else MessagePlayer(COLOR_RED + "You can't flip in races!", player);
            }
            else MessagePlayer(COLOR_RED + "You need $500 to flip your vehicle!", player);
        }
    }
}