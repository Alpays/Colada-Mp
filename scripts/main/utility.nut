/*

File: utility.nut

Description: File to add extra functions that vc-mp squirrel servers don't have by default.

*/

COLOR_RED       <- "[#FF3333]";
COLOR_BLACK     <- "[#000000]";
COLOR_YELLOW    <- "[#FFFF00]";
COLOR_GREEN     <- "[#36CE1F]";
COLOR_BLUE      <- "[#00FFFF]";
COLOR_ORANGE    <- "[#FF8000]";
COLOR_PINK      <- "[#FF99FF]";
COLOR_PURPLE    <- "[#CC00CC]";
COLOR_WHITE     <- "[#FFFFFF]";
COLOR_GRAY      <- "[#C0C0C0]";

// Custom vehicles.

VEH_PVOODOO <- 6400;
VEH_SHAMAL <- 6401;
VEH_MERCEDES <- 6402;
VEH_FERRARI <- 6403;
VEH_NISSAN <- 6404;
VEH_DELLY <- 6440;

// Custom weapons.

WEP_AK47 <- 100;
WEP_DEAGLE <- 101;

function formatNum(n) {
    local s = n.tostring();
    local out = "";

    while (s.len() > 3) {
        out = "," + s.slice(s.len() - 3) + out;
        s = s.slice(0, s.len() - 3);
    }

    out = s + out;
    return out;
}


function getWeaponType(weapon)
{
    switch(weapon)
    {
        case 0:
            return "Fist";
        case 1: case 2: case 3: 
        case 4: case 5: case 6: case 7:
        case 8: case 9: case 10: case 11:
            return "Melee";
        case 12: case 13: case 14: case 15:
            return "Grenade";
        case 17: case 18:
            return "Pistol";
        case 19: case 20: case 21: case 101:
            return "Shotgun";
        case 22: case 23: case 24: case 25:
            return "Submachine";
        case 26: case 27: case 100: 
            return "Rifle";
        case 28: case 29: 
            return "Sniper";
        case 30: case 31: case 32: case 33:
            return "Heavy";
        default:
            return "Unknown";
    }
}

function getBodypartName(bodypart)
{
    switch(bodypart)
    {
        case 0: return "Body";
        case 1: return "Torso";
        case 2: return "Left Arm";
        case 3: return "Right Arm";
        case 4: return "Left Leg";
        case 5: return "Right Leg";
        case 6: return "Head";
        default: return "Unknown";
    }
}

function getPartReason(reason) {
    switch(reason){
    case 0:
        return "Timeout";
    case 1:
        return "Disconnect";
    case 2:
        return "Kicked";
    case 3:
        return "Crashed";
    }
}

function CPlayer::IncCash(amount)
{
    if(Cash <= 99999999)
        Cash+=amount;
}

function CPlayer::DecCash(amount)
{
    if(Cash - amount < 0) Cash = 0;
    else Cash = Cash - amount;
}

function CPlayer::IncHealth(health)
{
    if(health + Health >= 100) Health = 100;
    else Health+=health;
}

function CPlayer::Drown(admin, reason)
{
    Pos = ::Vector(-149, 717, 6);
    ::Announce("Drowned!", this, 3);
    ::Message(::COLOR_BLUE + "Admin " + ::COLOR_WHITE + admin + ::COLOR_BLUE + " drowned " + ::COLOR_WHITE + Name + ::COLOR_BLUE + " reason: ( " + ::COLOR_WHITE + reason + ::COLOR_BLUE + " )");
}

function CPlayer::Slap(admin, reason)
{
    Pos = ::Vector(Pos.x, Pos.y, Pos.z + 5);
    ::Message(::COLOR_BLUE + "Admin " + ::COLOR_WHITE + admin + ::COLOR_BLUE + " slapped " + ::COLOR_WHITE + Name + ::COLOR_BLUE + " reason: ( " + ::COLOR_WHITE + reason + ::COLOR_BLUE + " )");
}

function CPlayer::Kick(admin, reason)
{
    ::Message(::COLOR_BLUE + "Admin " + ::COLOR_WHITE + admin + ::COLOR_BLUE + " kicked " + ::COLOR_WHITE + Name + ::COLOR_BLUE + " reason: ( " + ::COLOR_WHITE + reason + ::COLOR_BLUE + " )");
    ::KickPlayer(this);
}

function NumTok(string, separator) 
{ 
    local tokenized = split(string, separator); return tokenized.len(); 
}

function GetTok(string, separator, n, ...)
{
    if(string != null) {
        local m = vargv.len() > 0 ? vargv[0] : n,
        tokenized = split(string, separator),
        text = "";
        if (n > tokenized.len() || n < 1) return null;
        for (; n <= m; n++)
        {
            text += text == "" ? tokenized[n-1] : separator + tokenized[n-1];
        }
        return text;
    }
}

function random(min, max) {
    if ( min < max )
        return rand() % (max - min + 1) + min.tointeger();
    else if ( min > max )
        return rand() % (min - max + 1) + max.tointeger();
    else if ( min == max )
        return min.tointeger();
}

function SetPlayerWorld(playerID, world)
{
    local player = GetPlayer(playerID);
    if(player) 
    {
        player.World = world;
    }
}

function healPlayer(playerid)
{
    local player = GetPlayer(playerid);
    if(player)
    {
        local x = player.Pos.x, y = player.Pos.y
        if(x == playerData[player.ID].healPos.x && y == playerData[player.ID].healPos.y) 
        {
            player.Health = 100;
            player.DecCash(250);
            MessagePlayer(COLOR_GREEN + "Successfully healed for " + COLOR_WHITE + "$250!", player);
        }
        else MessagePlayer(COLOR_RED + "You have to stand still to heal!", player);
    }
    playerData[player.ID].healTimer = null;
}

function GetWeatherName(weather)
{
    switch(weather)
    {
        case 0: return "Mostly Clear";
        case 1: return "Overcast";
        case 2: return "Raining";
        case 3: return "Foggy";
        case 4: return "Sunny";
        case 5: return "Rain with Thunder";
        case 6: return "Dark Sky";
        case 7: return "Snow";
        default: return "Invalid";
    }
}

function GetVehicleType(model)
{
    switch(model)
    {
    case VEH_PCJ:
    case VEH_FAGGIO:
    case VEH_SANCHEZ:
    case VEH_FREEWAY:
    case VEH_ANGEL:
        return "Bike";
    case VEH_RCBANDIT:
    case VEH_RCBARON:
    case VEH_RCRAIDER:
    case VEH_RCGOBLIN:
        return "RC";
    case VEH_MAVERICK:
    case VEH_VCNMAVERICK:
    case VEH_POLICEMAVERICK:
    case VEH_SPARROW:
    case VEH_SEASPARROW:
    case VEH_HUNTER:
        return "Heli";
    case VEH_MARQUIS:
    case VEH_DINGHY:
    case VEH_COASTGUARD:
    case VEH_CUBANJETMAX:
    case VEH_TROPIC:
    case VEH_REEFER:
    case VEH_SPEEDER:
    case VEH_SQUALO:
    case VEH_PREDATOR:
        return "Boat";
    case VEH_SKIMMER:
    case VEH_SHAMAL:
        return "Plane";
    default:
        return "Land Vehicle";
    }
}

function getVehicleNameFromModel(model)
{
    if(model >= 130 && model <= 236)
    {
        return GetVehicleNameFromModel(model);
    }
    else {
        switch(model)
        {
            case 6400: return "Police Voodoo";
            case 6401: return "Shamal";
            case 6402: return "Mercedes Benz";
            case 6403: return "Ferrari F40";
            case 6404: return "Nissan Skyline R34"
            case 6440: return "Delly (Seby)";
            default: return "Unknown";
        }
    }
}

function isValidVehicle(model)
{
    if(GetVehicleNameFromModel(model) != null || model >= 6400)
    {
        return 1;
    }
    return 0;
}

function GetPlayer(plr) 
{
    switch(typeof(plr))
    {
        case "integer": return FindPlayer(plr);
        case "string":
        {
            if(IsNum(plr)) plr = plr.tointeger();
            return FindPlayer(plr);
        }
        default:
        {
            return null;
        }
    }
}

function EndPlayerSpawnProtection(playerid)
{
    if(GetPlayer(playerid))
    {
        if(!playerData[playerid].inRace || !playerData[playerid].racingVehicle) {
            local player = GetPlayer(playerid);
            playerData[player.ID].spawnTimer = null;
            player.Immunity = 0;
        }   
    }
}

function getVehiclePlayerCount(vehicle)
{
    local count = 0;
    for(local i = 0; i < 4; ++i)
    {
        if(vehicle.GetOccupant(i)) count++;
    }
    return count;
}

// These are utility functions to add beta weapons names/ids

function getWeaponName(weapon)
{
    if(weapon < 100) return GetWeaponName(weapon);
    else {
        switch(weapon)
        {
            case 100: return "AK-47";
            case 101: return "Deagle";
            default: return "Unknown";
        }
    }
}

function getWeaponID(weapon)
{
    local wepID = GetWeaponID(weapon);
    if(wepID == 255) {
        if(weapon.tolower().find("ak") != null) return 100;
        if(weapon.tolower().find("de") != null) return 101;
    }
    return GetWeaponID(weapon);
}

function isAccountCommand(cmd)
{
    switch(cmd)
    {
        case "register":
        case "login":
        case "changepass":
            return 1;
        default:
            return 0;
    }
}

function GetLocation(x, y)
{
    local locationname = GetDistrictName(x, y);
    if(locationname == "Downtown Vice City") locationname = "Downtown";
    return locationname;    
}