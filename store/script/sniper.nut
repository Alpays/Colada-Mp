line3d <- {
  "list" : {},
  "del" : function(id){
    if(::line3d.list.rawin(id)){
      return ::line3d.list.rawdelete(id);
    }
  },
  "set" : function(id, color, from, to){
    if(::line3d.list.rawin(id)){
      return ::line3d.update(id, from, to);
    }
    local item = {
      "id" : id,
      "pos" : {
        "from" : ::Vector(0, 0, 0),
        "to" : ::Vector(0, 0, 0)
      },
      "dist" : 0
      "raw" : []
    }
    for(local j = 0; j < 4; j++){
      local ca = ::GUICanvas();
      ca.Colour = color;
      ca.Position = ::VectorScreen(0, 0);
      ca.Size = ::VectorScreen(1, 1);
      ca.AddFlags(GUI_FLAG_BACKGROUND | GUI_FLAG_3D_ENTITY);
      ca.Position3D = ::Vector(0.0,0.0,0.0);
      ca.Rotation3D = ::Vector(0.0,0.0,0.0);
      if(j < 2){
        ca.Size3D = ::Vector(0.01, 0.01, 0.0);
      } else {
        ca.Size3D = ::Vector(0.01, 0.01, 0.0);
      }
      item.raw.push(ca);
    }
    ::line3d.list.rawset(id, item);
    return ::line3d.update(id, from, to);
  },
  "update" : function(id, from, to){
    if(::line3d.list.rawin(id)){
      local item = ::line3d.list.rawget(id);
      item.pos.from = ::Vector(from.X, from.Y, from.Z);
      item.pos.to = ::Vector(to.X, to.Y, to.Z);
      item.dist = ::line3d.dist_3d(from.X, from.Y, from.Z, to.X, to.Y, to.Z);

      local lp2 = item.pos.from;
      local lp = item.pos.to;
      local fp = ::Vector(lp2);
      local fp0 = ::Vector(lp);

      for(local j = 0; j < 4; j++){
        if(0 == j){
          local rot = ::line3d.rotate1(lp.X, lp.Y, lp.Z, lp2.X, lp2.Y, lp2.Z);
          rot.X += -1.570796;
          item.raw[j].Rotation3D = ::Vector(rot);
          local pitch = rot.X;
          local yaw = rot.Z;
          local rel_y = 1;
          local reloffset = sin(pitch) + 1;
          local X = fp.X + -0.005 * cos(yaw) - ((rel_y * -2) + rel_y + reloffset) * sin(yaw);
          local Y = fp.Y + -0.005 * sin(yaw) + ((rel_y * -2) + rel_y + reloffset) * cos(yaw);
          local Z = fp.Z + 1 + cos(pitch) * -1;
          item.raw[j].Size3D.Y = item.dist;
          item.raw[j].Position3D = ::Vector(X, Y, Z);
        } else if(1 == j){
          local rot = ::line3d.rotate1(lp.X, lp.Y, lp.Z, lp2.X, lp2.Y, lp2.Z);
          rot.X += 1.570796;
          item.raw[j].Rotation3D = ::Vector(rot);
          local pitch = rot.X;
          local yaw = rot.Z;
          local rel_y = 1;
          local reloffset = sin(pitch) + 1;
          local X = fp0.X + -0.005 * cos(yaw) - ((rel_y * -2) + rel_y + reloffset) * sin(yaw);
          local Y = fp0.Y + -0.005 * sin(yaw) + ((rel_y * -2) + rel_y + reloffset) * cos(yaw);
          local Z = fp0.Z + 1 + cos(pitch) * -1;
          item.raw[j].Size3D.Y = item.dist;
          item.raw[j].Position3D = ::Vector(X, Y, Z);
        } else if(2 == j){
          local rot = ::line3d.rotate2(lp.X, lp.Y, lp.Z, lp2.X, lp2.Y, lp2.Z);
          rot.X += -1.570796;
          item.raw[j].Rotation3D = ::Vector(rot);
          local pitch = rot.X;
          local yaw = rot.Z;
          local rel_y = 1;
          local reloffset = sin(pitch) + 1;
          local X = fp.X + -0.005 * cos(yaw) - ((rel_y * -2) + rel_y + reloffset) * sin(yaw);
          local Y = fp.Y + -0.005 * sin(yaw) + ((rel_y * -2) + rel_y + reloffset) * cos(yaw);
          local Z = fp.Z + 1 + cos(pitch) * -1;
          item.raw[j].Size3D.X = item.dist;
          item.raw[j].Position3D = ::Vector(X, Y, Z);
        } else if(3 == j){
          local rot = ::line3d.rotate2(lp.X, lp.Y, lp.Z, lp2.X, lp2.Y, lp2.Z);
          rot.X += 1.570796;
          item.raw[j].Rotation3D = ::Vector(rot);
          local pitch = rot.X;
          local yaw = rot.Z;
          local rel_y = 1;
          local reloffset = sin(pitch) + 1;
          local X = fp.X + -0.005 * cos(yaw) - ((rel_y * -2) + rel_y + reloffset) * sin(yaw);
          local Y = fp.Y + -0.005 * sin(yaw) + ((rel_y * -2) + rel_y + reloffset) * cos(yaw);
          local Z = fp.Z + 1 + cos(pitch) * -1;
          item.raw[j].Size3D.X = item.dist;
          item.raw[j].Position3D = ::Vector(X, Y, Z);
        }
      }
    }
  },
  "dist_2d" : function (x, y, x2, y2){
    return ::sqrt((x - x2)*(x - x2) + (y - y2)*(y - y2));
  },
  "dist_3d" : function (x, y, z, x2, y2, z2){
    return ::sqrt((x - x2)*(x - x2) + (y - y2)*(y - y2) + (z - z2)*(z - z2));
  },
  "rotate1" : function(x1, y1, z1, x2, y2, z2){
    local rotx = ::atan2(z2 - z1, ::line3d.dist_2d(x1, y1, x2, y2));
    rotx = rotx - 1.570796;
    local rotz = -1 * ::atan2( x2 - x1, y2 - y1 );
    if(rotz < -3.141592){
      rotz = rotz + 6.283184;
    }
    return ::Vector(rotx, 0,rotz);
  },
  "rotate2" : function(x1, y1, z1, x2, y2, z2){
    local rotx = ::atan2(z2 - z1, ::line3d.dist_2d(x1, y1, x2, y2));
    local rotz = -1 * ::atan2( x2 - x1, y2 - y1 );
    rotz = rotz + -1.570796;
    if(rotz < -3.141592){
      rotz = rotz + 6.283184;
    }
    local roty = ::atan2(z2 - z1, ::line3d.dist_2d(x1, y1, x2, y2));
    rotx = rotx - roty;
    return ::Vector(rotx, roty,rotz);
  }
}

laser_sniper <- {
    "last_update" : {},
    "last_call" : ::Script.GetTicks(),
    "laser_on_hands" : 0,
  "proc" : function(){
        local ticks = ::Script.GetTicks();
        if((ticks - ::laser_sniper.last_call) > 100){ // less = smoother but more bandwidth usage
            ::laser_sniper.last_call = ticks;
            if(laser_sniper.laser_on_hands == 1){
                local player = ::World.FindLocalPlayer();
                if(player&&(player.Position.Y != 0)&&(player.Position.X != 0)){
                    local screen_size = ::GUI.GetScreenSize();
                    local camera_pos_from = ::GUI.ScreenPosToWorld(::Vector(screen_size.X * 0.5, screen_size.Y * 0.5, -1));
                    local dist = ::line3d.dist_3d(camera_pos_from.X, camera_pos_from.Y, camera_pos_from.Z, player.Position.X, player.Position.Y, player.Position.Z + 0.2);
                    if(dist < 0.7){ // camera near head - so player is most likely aiming (server will check it to be sure)
                        local camera_pos_to = ::GUI.ScreenPosToWorld(::Vector(screen_size.X * 0.5, screen_size.Y * 0.5, 1));
                        local s = Stream();
                        s.WriteByte(101);
                        s.WriteFloat(camera_pos_from.X);
                        s.WriteFloat(camera_pos_from.Y);
                        s.WriteFloat(camera_pos_from.Z);
                        s.WriteFloat(camera_pos_to.X);
                        s.WriteFloat(camera_pos_to.Y);
                        s.WriteFloat(camera_pos_to.Z);
                        ::Server.SendData(s);
                    }
                }
            }

            foreach(key, value in ::laser_sniper.last_update){
                if((ticks - value) > 650){ // remove outdated lasers
                    ::line3d.del("player_laser"+ key);
                    ::laser_sniper.last_update.rawdelete(key);
                }
            }
        }
  },
  "on_server_data" : function(stream){
        local laser_netcode = stream.ReadByte();
        if(laser_netcode == 1){
            laser_sniper.laser_on_hands = 1;
        } else if(laser_netcode == 2){
            laser_sniper.laser_on_hands = 0;
        } else if(laser_netcode == 3){
            local id = stream.ReadByte();
            ::laser_sniper.last_update.rawset(id, ::Script.GetTicks());
            local x1 = stream.ReadFloat();
            local y1 = stream.ReadFloat();
            local z1 = stream.ReadFloat();
            local x2 = stream.ReadFloat();
            local y2 = stream.ReadFloat();
            local z2 = stream.ReadFloat();
            local dist = ::line3d.dist_3d(x1, y1, z1, x2, y2, z2);
            local vx1 = x1 + ((x2 - x1) / dist); // add one unit (meter) gap front player, visual only
            local vy1 = y1 + ((y2 - y1) / dist);
            local vz1 = z1 + ((z2 - z1) / dist);

            local local_player = ::World.FindLocalPlayer();
            local player = ::World.FindPlayer(id);
            if(local_player&&player&&(local_player.ID != player.ID)&&(player.Position.Y != 0)&&(player.Position.X != 0)){
                local rt = ::RayTrace(::Vector(x1, y1, z1), ::Vector(x2, y2, z2), RAY_BUILDING |  RAY_VEHICLE | RAY_OBJECT);
                local rt_ped = ::RayTrace(::Vector(vx1, vy1, vz1), ::Vector(x2, y2, z2), RAY_PED);
                if(rt.Collided){
                    local rt_hit = ::Vector(rt.Position.X, rt.Position.Y, rt.Position.Z);
                    local dist_cam_to_hit = ::line3d.dist_3d(x1, y1, z1, rt_hit.X, rt_hit.Y, rt_hit.Z);
                    local dist_cam_to_vcam = ::line3d.dist_3d(x1, y1, z1, vx1, vy1, vz1);
                    if(dist_cam_to_vcam > dist_cam_to_hit){
                        ::line3d.del("player_laser"+ id);
                    } else {
                        if(rt_ped.Collided){
                            local rt_ped_hit = ::Vector(rt_ped.Position.X, rt_ped.Position.Y, rt_ped.Position.Z);
                        ::line3d.set("player_laser"+ id, ::Colour(255,0,0,200), ::Vector(vx1, vy1, vz1), ::Vector(rt_ped_hit.X, rt_ped_hit.Y, rt_ped_hit.Z));
                        } else {
                            ::line3d.set("player_laser"+ id, ::Colour(255,0,0,200), ::Vector(vx1, vy1, vz1), ::Vector(rt_hit.X, rt_hit.Y, rt_hit.Z));
                        }
                    }
                } else {
                    if(rt_ped.Collided){
                        local rt_ped_hit = ::Vector(rt_ped.Position.X, rt_ped.Position.Y, rt_ped.Position.Z);
                        ::line3d.set("player_laser"+ id, ::Colour(255,0,0,200), ::Vector(vx1, vy1, vz1), ::Vector(rt_ped_hit.X, rt_ped_hit.Y, rt_ped_hit.Z));
                    } else {
                        ::line3d.set("player_laser"+ id, ::Colour(255,0,0,200), ::Vector(vx1, vy1, vz1), ::Vector(x2, y2, z2));
                    }
                }
            }
        } else if(laser_netcode == 4){
            local id = stream.ReadByte();
            ::line3d.del("player_laser"+ id);
            if(::laser_sniper.last_update.rawin(id)){
                ::laser_sniper.last_update.rawdelete(id);
            }
        }
  }
}