/*

File: personal_vehicle.nut

Description: Vehicle owning system.

*/


function GetVehiclePrice(vehiclemodel)
{
    switch(vehiclemodel)
    {
        case VEH_LANDSTALKER: return 70000;
        case VEH_IDAHO: return 85000;       
        case VEH_STINGER: return 150000;
        case VEH_SENTINEL: return 100000;
        case VEH_INFERNUS: return 200000;
        case VEH_VOODOO: return 95000;
        case VEH_PONY: return 75000;
        case VEH_CHEETAH: return 175000;
        case VEH_TAXI: return 90000;
        case VEH_POLICE: return 72500;
        case VEH_BANSHEE: return 125000;
        case VEH_CUBANHERMES: return 110000;
        case VEH_ANGEL: return 135000;
        case VEH_CABBIE: case VEH_KAUFMAN: return 97500;
        case VEH_SENTINELXS: return 115000;
        case VEH_PIZZABOY: return 85000;
        case VEH_GANGBURRITO: return 100000;
        case VEH_ZEBRA: return 116000;
        case VEH_PCJ: return 190000;
        case VEH_SANCHEZ: return 144000;
        case VEH_SABRE: return 67000;
        case VEH_SABRETURBO: return 87000;
        case VEH_WALTON: return 40000;
        case VEH_COMET: return 132000;
        case VEH_DELUXO: return 130000;
        case VEH_HOTRING1: case VEH_HOTRING2: case VEH_HOTRING3: return 215000;
        case VEH_PVOODOO: return 150000;
        case VEH_MERCEDES: return 375000;
        case VEH_FERRARI: return 1000000;
        case VEH_NISSAN: return 850000;
        default: return "Not for Sale";
    }
}

function BuyCar(player, slot)
{
    local veh = player.Vehicle;
    if(playerData[player.ID].logged)
    {
        if(player.Vehicle)
        {
            local vehPrice = GetVehiclePrice(veh.Model);
            if(vehPrice != 0)
            {
                if(player.Cash >= vehPrice)
                {
                    local carSlot = -1;
                    local q = QuerySQL(accounts.db, "SELECT * FROM accounts WHERE name='"+player.Name+"' COLLATE NOCASE");
                    if(q)
                    {
                        switch(slot)
                        {
                            case 1:
                                carSlot = GetSQLColumnData(q, 12);
                                if(carSlot == 0)
                                {
                                    player.DecCash(vehPrice);
                                    playerData[player.ID].car1 = veh.Model;
                                    QuerySQL(accounts.db, "UPDATE accounts SET vehicle='"+veh.Model+"' WHERE name='"+player.Name+"' COLLATE NOCASE");
                                    MessagePlayer(COLOR_BLUE + "Successfully purchased a " + COLOR_WHITE + getVehicleNameFromModel(veh.Model) + COLOR_BLUE + " use /getcar1 to spawn it.", player);
                                }
                                else MessagePlayer(COLOR_RED + "You already have a vehicle for this slot!", player);
                                break;
                            case 2:
                                carSlot = GetSQLColumnData(q, 13);
                                if(carSlot == 0)
                                {
                                    player.DecCash(vehPrice);
                                    playerData[player.ID].car2 = veh.Model;
                                    QuerySQL(accounts.db, "UPDATE accounts SET vehicle2='"+veh.Model+"' WHERE name='"+player.Name+"' COLLATE NOCASE");
                                    MessagePlayer(COLOR_BLUE + "Successfully purchased a " + COLOR_WHITE + getVehicleNameFromModel(veh.Model) + COLOR_BLUE + " use /getcar2 to spawn it.", player);
                                } 
                                else MessagePlayer(COLOR_RED + "You already have a vehicle for this slot!", player);
                                break;
                        }
                        FreeSQLQuery(q);
                    }
                }
                else MessagePlayer(COLOR_RED + "You need " + vehPrice + " to buy this vehicle!" ,player)
            }
            else MessagePlayer(COLOR_RED + "This vehicle is not for sale!", player);
        } 
        else MessagePlayer(COLOR_RED + "Enter the vehicle you wish to buy first!", player);
    }
    else MessagePlayer(COLOR_RED + "You have to be registered/logged to use this command!", player);
}

function GetCar(player, slot)
{
    if(playerData[player.ID].logged)
    {
        if(player.IsSpawned)
        {
            if(playerData[player.ID].lastSpawnTime) {
                if(time() - playerData[player.ID].lastSpawnTime < 20) {
                    MessagePlayer(COLOR_RED + "You have to wait for 20 seconds to use this command!", player);
                    return;
                }
            }
            local q = QuerySQL(accounts.db, "SELECT * FROM accounts WHERE name='"+player.Name+"'")
            if(q)
            {
                local model;
                switch(slot) {
                    case 1:
                        model = GetSQLColumnData(q, 12);
                        break;
                    case 2:
                        model = GetSQLColumnData(q, 13);
                        break;
                }
                if(model == 0) {
                    MessagePlayer(COLOR_RED + "You don't own a vehicle in this slot!", player);
                    FreeSQLQuery(q);
                    return;
                }
                if(playerData[player.ID].currentCar)
                {
                    playerData[player.ID].currentCar.Delete();
                }
                playerData[player.ID].currentCar = CreateVehicle( model, 1, player.Pos, player.Angle, random(1, 90), 1 );
                playerData[player.ID].lastSpawnTime = time();
                playerData[player.ID].currentCar.SingleUse = true;
                MessagePlayer(COLOR_BLUE + "Successfully spawned " + COLOR_WHITE + getVehicleNameFromModel(model), player);
                FreeSQLQuery(q);
            }
        }
        else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
    }
    else MessagePlayer(COLOR_RED + "You have to be logged in to use this command!", player);
}

function SellCar(player, slot)
{
    if(playerData[player.ID].logged)
    {
        local q = QuerySQL(accounts.db, "SELECT * FROM accounts WHERE name='"+player.Name+"'")
        if(q)
        {
            local model;
            switch(slot) {
                case 1: model = GetSQLColumnData(q, 12); break;
                case 2: model = GetSQLColumnData(q, 13); break;
            }
            if(model == 0) { 
                MessagePlayer(COLOR_RED + "You don't own a vehicle in this slot!", player);
                FreeSQLQuery(q);
                return;
            }
            local price = (GetVehiclePrice(model) / 2);
            player.IncCash(price);
            switch(slot) {
                case 1:
                    QuerySQL(accounts.db, "UPDATE accounts SET vehicle='0' WHERE name='"+player.Name+"' COLLATE NOCASE");
                    playerData[player.ID].car1 = 0;
                    break;
                case 2:
                    QuerySQL(accounts.db, "UPDATE accounts SET vehicle2='0' WHERE name='"+player.Name+"' COLLATE NOCASE");
                    playerData[player.ID].car2 = 0;
                    break;
            }
            MessagePlayer(COLOR_BLUE + "You have successfully sold " + COLOR_WHITE + getVehicleNameFromModel(model) + COLOR_BLUE + " for " + COLOR_WHITE + price + "$", player);
            FreeSQLQuery(q);
        }
    }
}

function onPlayerCommand(player, cmd, text)
{
    switch(cmd.tolower())
    {
        case "car":
        {
            if(player.Vehicle) {
                local veh = player.Vehicle;
                MessagePlayer(COLOR_BLUE + "You are currently driving a " + COLOR_WHITE + getVehicleNameFromModel(veh.Model) + COLOR_BLUE + " Price: $" + COLOR_WHITE + formatNum(GetVehiclePrice(veh.Model)), player);
            }
            else MessagePlayer(COLOR_RED + "You are not driving a vehicle!", player);
            break;
        }
        case "mycars":
        {
            local veh1 = getVehicleNameFromModel(playerData[player.ID].car1);
            local veh2 = getVehicleNameFromModel(playerData[player.ID].car2);
            if(veh1 == "Unknown") veh1 = "-";
            if(veh2 == "Unknown") veh2 = "-";
            if(veh1 == "Voodoo") veh1 = "Voodoo Magic";
            if(veh2 == "Voodoo") veh2 = "Voodoo Magic";
            MessagePlayer(COLOR_BLUE + "Vehicle in slot 1: " + COLOR_WHITE + veh1 + COLOR_BLUE + " vehicle in slot 2: " + COLOR_WHITE + veh2, player );
            break;
        }
        case "buycar1":
        {
            BuyCar(player, 1);
            break;
        }
        case "buycar2":
        {
            BuyCar(player, 2);
            break;
        }
        case "getcar1":
        {
            GetCar(player, 1);
            break;
        }
        case "getcar2":
        {
            GetCar(player, 2);
            break;
        }
        case "sellcar1":
        {
            SellCar(player, 1);
            break;
        }
        case "sellcar2":
        {
            SellCar(player, 2);
            break;
        }
    }
}