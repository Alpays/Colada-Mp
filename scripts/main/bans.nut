/*

File: bans.nut

Description: Ban system with temp bans feature.

*/

class Bans
{
    db = null;

    function onScriptLoad() 
    {
        db = ::ConnectSQL("bans.db");

        ::QuerySQL(db, "CREATE TABLE IF NOT EXISTS bans(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, uid TEXT, uid2 TEXT, ip TEXT, duration INTEGER, isperma BOOL, admin TEXT, reason TEXT)");
    }
    function onScriptUnload()
    {
        ::DisconnectSQL(db);
    }
    function onPlayerJoin(player)
    {
        player.IsBanned();
    }

    function Ban(name, admin, reason)
    {
        local player = ::GetPlayer(name);
        ::QuerySQL(db, format("INSERT INTO bans(name, uid, uid2, ip, isperma, admin, reason) VALUES('%s', '%s', '%s', '%s', '%d', '%s', '%s')", player.Name, player.UniqueID, player.UniqueID2, player.IP, 1, admin, reason));
        ::MessagePlayer(COLOR_RED + "Banned!", player);
        ::Message(COLOR_BLUE + "Admin " + COLOR_WHITE + admin + COLOR_BLUE + " banned " + COLOR_WHITE + player.Name + COLOR_BLUE + " reason: " + COLOR_WHITE + reason);
        ::KickPlayer(player);
    }
    function BanIP(ip, admin, reason)
    {
        ::QuerySQL(db, format("INSERT INTO bans(ip ,admin, reason) VALUES('%s', '%s', '%s')", ip,admin,reason));
    }
    function TempBan(name, admin, duration, reason)
    {
        local player = ::GetPlayer(name);
        duration = ConvertBanTime(duration);
        if(duration)
        {
            ::QuerySQL(db, format("INSERT INTO bans(name, uid, uid2, ip, duration, isperma, admin, reason) VALUES('%s','%s','%s','%s','%d','%d','%s','%s')", player.Name, player.UniqueID, player.UniqueID2, player.IP, ::time() + duration, 0, admin, reason));
            ::MessagePlayer(COLOR_RED + "Banned!", player);
            ::Message(COLOR_BLUE + "Admin " + COLOR_WHITE + admin + COLOR_BLUE + " banned " + COLOR_WHITE + player.Name + COLOR_BLUE + " reason: " + COLOR_WHITE + reason + COLOR_BLUE + " time left: " + COLOR_WHITE + ConvertSecondsToDate(duration));
            ::KickPlayer(player);
            return true;
        }
        return false;
    }
    function IsBanned(name)
    {
        local q = ::QuerySQL(db, "SELECT * FROM bans WHERE name='"+name+"' COLLATE NOCASE");
        if(q) {
            ::FreeSQLQuery(q);
            return true;
        }
        return false;
    }
    function IsBannedIP(ip_address)
    {
        local q = ::QuerySQL(db, "SELECT * FROM bans WHERE ip='"+ip_address+"'");
        if(q) {
            ::FreeSQLQuery(q);
            return true;
        }
        return false;
    }
    function Unban(name)
    {
        local q = ::QuerySQL(db, "SELECT * FROM bans WHERE name='"+name+"' COLLATE NOCASE");
        if(q) {
            ::QuerySQL(db, "DELETE from bans WHERE name='"+name+"' COLLATE NOCASE");
            ::FreeSQLQuery(q);
            return true;
        }
        return false;
    }
    function UnbanIP(ip_address)
    {
        local q = ::QuerySQL(db, "SELECT * FROM bans WHERE ip='"+ip_address+"'");
        if(q) {
            ::QuerySQL(db, "DELETE from bans WHERE ip='"+ip_address+"'");
            ::FreeSQLQuery(q);
            return true;
        }
        return false;        
    }
    function ConvertBanTime(duration)
    {
        if(duration.find("m"))
        {
            duration = duration.slice(0, duration.find("m"));
            if(duration && ::IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60
                return duration;
            }
        }
        else if(duration.find("h"))
        {
            duration = duration.slice(0, duration.find("h"));
            if(duration && ::IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60
                duration = duration * 60
                return duration;
            }
        }    
        else if(duration.find("d"))
        {
            duration = duration.slice(0, duration.find("d"));
            if(duration && ::IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60;
                duration = duration * 60;
                duration = duration * 24;
                return duration;
            }
        }
        else if(duration.find("w"))
        {
            duration = duration.slice(0, duration.find("w"));
            if(duration && ::IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60;
                duration = duration * 60;
                duration = duration * 24;
                duration = duration * 7;
                return duration;
            }
        }
    }
    function ConvertSecondsToDate(seconds)
    {
        local weekcount = 0;
        local daycount = 0;
        local hourcount = 0;
        local minutecount = 0;
        weekcount = seconds / 604800;
        seconds-= weekcount * 604800;

        daycount = seconds / 86400;
        seconds-= daycount * 86400;

        hourcount = seconds / 3600;
        seconds-= hourcount * 3600;

        minutecount = seconds / 60;
        seconds-= minutecount * 60;
        
        if(weekcount) 
        {
            if(daycount)
            {
                return weekcount.tostring() + " weeks " + daycount + " days.";
            }
            return weekcount.tostring() + " weeks ";
        } 
        else if(daycount)
        {
            if(hourcount)
            {
                return daycount.tostring() + " days " + hourcount + " hours.";
            }
            return daycount.tostring() + " days.";
        }
        else if(hourcount)
        {
            return hourcount.tostring() + " hours " + minutecount + " minutes.";
        }
        else if(minutecount) 
        { 
            return minutecount.tostring() + " minutes.";
        }
        else return seconds.tostring() + " seconds.";
    } 

}

bans <- Bans();

function CPlayer::IsBanned()
{
    local q = ::QuerySQL(::bans.db, "SELECT * FROM bans WHERE name='"+Name+"' or uid='"+UniqueID+"' or uid2='"+UniqueID2+"' or ip='"+IP+"' COLLATE NOCASE")
    if(q) {
        local isPerma = ::GetSQLColumnData(q, 6);
        local admin = ::GetSQLColumnData(q, 7);
        local reason = ::GetSQLColumnData(q, 8);
        if(isPerma) {
            ::Message(::COLOR_RED + "Enforcing permanent ban on: " + ::COLOR_WHITE + Name + ::COLOR_RED + " admin: " + ::COLOR_WHITE + admin + ::COLOR_RED + " reason: " + ::COLOR_WHITE + reason);
            ::MessagePlayer("Your ban ID: " + ::GetSQLColumnData(q, 0), this);
            ::KickPlayer(this);
        }
        else {
            if(::time() >= ::GetSQLColumnData(q, 5)) // If ban time is expired.
            {
                ::QuerySQL(::bans.db, "DELETE FROM bans WHERE id='"+::GetSQLColumnData(q, 0)+"'");
            }
            else {
                local timeleft = ::bans.ConvertSecondsToDate(::GetSQLColumnData(q, 5) - ::time());
                ::Message(::COLOR_RED + "Enforcing temporary ban on: " + ::COLOR_WHITE + Name + ::COLOR_RED + " admin: " + ::COLOR_WHITE + admin + ::COLOR_RED + " reason: " + ::COLOR_WHITE + reason + ::COLOR_RED + " duration: " + ::COLOR_WHITE + timeleft);
                ::MessagePlayer("Your ban ID: " + ::GetSQLColumnData(q, 0), this);
                ::KickPlayer(this);
            }
        }
        ::FreeSQLQuery(q);
    }
}
