function onPlayerWeaponChange(player, old, new){
    if(new == 29){
        playerData[player.ID].laser = true;

        local s = ::Stream();
        s.StartWrite();
        s.WriteByte(101);
        s.WriteByte(1);
        s.SendStream(player); // send to aimer

    } else if(playerData[player.ID].laser){
        playerData[player.ID].laser = false;

        local s = ::Stream();
        s.StartWrite();
        s.WriteByte(101);
        s.WriteByte(2);
        s.SendStream(player); // send to aimer
    }
}

function onPlayerActionChange(player, old, new){
    if(12 == old){
        if(!((KEY_ONFOOT_AIM & player.GameKeys) != 0)){
            local s = ::Stream();
            s.StartWrite();
            s.WriteByte(101);
            s.WriteByte(4);
            s.WriteByte(player.ID);
            s.SendStream(null); // send to all players
        }
    }
}

function onClientScriptData(player){
    local netcode = ::Stream.ReadByte();
    if(netcode == 101){ // input of aim position, check if player is really aiming then send to all players
        if(
            (player.Weapon == 29)
            &&
            (!player.Away)
            &&
            (player.IsSpawned)
            &&
            (player.Health > 1)
            &&
            (player.State == 2) // shooting ("aim") sync
            &&
            (
                (player.Action == 1) // reload laser sniper rifle
                ||
                (player.Action == 12) // aiming
            )
            &&
            ((KEY_ONFOOT_AIM & player.GameKeys) != 0) // player is holding aim hey
        ){
            local id = player.ID;
            local x1 = ::Stream.ReadFloat();
            local y1 = ::Stream.ReadFloat();
            local z1 = ::Stream.ReadFloat();
            local x2 = ::Stream.ReadFloat();
            local y2 = ::Stream.ReadFloat();
            local z2 = ::Stream.ReadFloat();
            local s = ::Stream();
            s.StartWrite();
            s.WriteByte(101);
            s.WriteByte(3);
            s.WriteByte(player.ID);
            s.WriteFloat(x1);
            s.WriteFloat(y1);
            s.WriteFloat(z1);
            s.WriteFloat(x2);
            s.WriteFloat(y2);
            s.WriteFloat(z2);
            s.SendStream(null); // send to all players
        } else {
            local s = ::Stream();
            s.StartWrite();
            s.WriteByte(101);
            s.WriteByte(4);
            s.WriteByte(player.ID);
            s.SendStream(null); // send to all players
        }
    }
}