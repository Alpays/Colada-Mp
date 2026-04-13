function onPlayerEnterVehicle( player, vehicle, door ) {
    if(GetVehicleType(vehicle.Model) == "Land Vehicle")
    {
        if(player.VehicleSlot == 0 || player.VehicleSlot == 1) // Player can only see car's speed if they're sitting front.
        {
            local str = Stream();
            str.StartWrite();
            str.WriteByte(STREAM_VEHENTER);
            str.WriteInt(vehicle.ID);
            str.SendStream(player);  
        }
    }
}

function onPlayerExitVehicle( player, vehicle ) {
    local str = Stream();
    str.StartWrite();
    str.WriteByte(STREAM_VEHEXIT);
    str.SendStream(player);  
}
