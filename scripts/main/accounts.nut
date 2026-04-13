/*

File: accounts.nut

Description: Account system to save stats.

*/

class Accounts 
{
    db = null;
    function onScriptLoad() {

        db = ConnectSQL("accounts.db");
        /*
        id = 0 
        name 1
        pass 2
        autologin 3
        uid 4
        uid2 5
        ip 6
        kills 7
        deaths 8
        topspree 9
        headshots 10
        money 11
        veh1 12
        veh2 13
        adminlevel 14
        */
        ::QuerySQL(db, "CREATE TABLE IF NOT EXISTS accounts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, password TEXT, autologin INTEGER DEFAULT 1, uid TEXT, uid2 TEXT, ip TEXT, kills INTEGER DEFAULT 0, deaths INTEGER DEFAULT 0, topspree INTEGER DEFAULT 0, headshots INTEGER DEFAULT 0, money INTEGER DEFAULT 0, vehicle INTEGER DEFAULT 0, vehicle2 INTEGER DEFAULT 0, adminlevel INTEGER DEFAULT 0)")
    }

    function IsRegistered(player) {
        local q = ::QuerySQL(db, "SELECT * FROM accounts WHERE name='"+player.Name+"' COLLATE NOCASE");
        if(q) {
            ::FreeSQLQuery(q);
            return true;
        }
        return false;
    }

    function Register(player, password) {
        if(player) {
            ::QuerySQL(db, ::format("INSERT INTO ACCOUNTS(name,password,ip,uid,uid2) VALUES('%s','%s','%s','%s','%s')",player.Name, ::SHA512(password), player.IP, player.UniqueID, player.UniqueID2));
            playerData[player.ID].registered = true;
            playerData[player.ID].logged = true;
            stuntjumps.RegisterStuntDatabase(player);
            ::MessagePlayer(COLOR_GREEN + "You have successfully registered!", player);
            ::MessagePlayer(COLOR_GREEN + "You got $2500 as registration bonus!", player);
            player.IncCash(2500);
        }
    }

    function Login(player, password) {
        if(player) {
            local q = ::QuerySQL(db, "SELECT * FROM ACCOUNTS WHERE name='"+player.Name+"' COLLATE NOCASE");
            if(q) {
                local cryptedpass = ::GetSQLColumnData(q, 2);
                if(::SHA512(password) == cryptedpass) {
                    playerData[player.ID].logged = true;
                    playerData[player.ID].kills = ::GetSQLColumnData(q, 7);
                    playerData[player.ID].deaths = ::GetSQLColumnData(q, 8);
                    playerData[player.ID].topSpree = ::GetSQLColumnData(q, 9);
                    playerData[player.ID].headshots = ::GetSQLColumnData(q, 10);
                    player.Cash = ::GetSQLColumnData(q, 11);
                    playerData[player.ID].car1 = ::GetSQLColumnData(q, 12);
                    playerData[player.ID].car2 = ::GetSQLColumnData(q, 13);
                    playerData[player.ID].adminLevel = ::GetSQLColumnData(q, 14);
                    stuntjumps.LoadStunts(player);
                    ::MessagePlayer(COLOR_GREEN + "You have successfully logged in to your account!", player);
                    ::FreeSQLQuery(q);
                }   
                else ::MessagePlayer(COLOR_RED + "Wrong password entered!", player);
            }
        }
    }

    function AutoLogin(player) {
        if(player) {
            local q = ::QuerySQL(db, "SELECT * FROM ACCOUNTS WHERE name='"+player.Name+"' COLLATE NOCASE");
            playerData[player.ID].logged = true;
            playerData[player.ID].kills = ::GetSQLColumnData(q, 7);
            playerData[player.ID].deaths = ::GetSQLColumnData(q, 8);
            playerData[player.ID].topSpree = ::GetSQLColumnData(q, 9);
            playerData[player.ID].headshots = ::GetSQLColumnData(q, 10);
            player.Cash = ::GetSQLColumnData(q, 11);
            playerData[player.ID].car1 = ::GetSQLColumnData(q, 12);
            playerData[player.ID].car2 = ::GetSQLColumnData(q, 13);
            playerData[player.ID].adminLevel = ::GetSQLColumnData(q, 14);
            stuntjumps.LoadStunts(player);
            ::FreeSQLQuery(q);
        }
    }

    function LogOut(player) {
        if(player) {
            if(playerData[player.ID].logged) {
                SaveData(player.ID);
                playerData[player.ID].logged = false;
            }
        }
    }

    function SaveData(playerid) {
        local player = ::GetPlayer(playerid)
        if(player && playerData[player.ID].logged) {
            local p = playerData;
            local id = player.ID;
            ::QuerySQL(db, format("UPDATE accounts SET kills='%d', deaths='%d', topspree='%d', headshots='%d', adminlevel='%d', money='%d', vehicle='%d', vehicle2='%d', ip='%s', uid='%s', uid2='%s' WHERE name='%s' COLLATE NOCASE", p[id].kills, p[id].deaths, p[id].topSpree, p[id].headshots, p[id].adminLevel, player.Cash, p[id].car1, p[id].car2, player.IP, player.UniqueID, player.UniqueID2, player.Name));
        }
    }

    function ChangePass(player, password)
    {
        local q = ::QuerySQL(db, "SELECT * FROM accounts WHERE name='"+player.Name+"' COLLATE NOCASE");
        if(q)
        {
            ::QuerySQL(db, "UPDATE accounts SET password='"+::SHA512(password)+"' WHERE name='"+player.Name+"' COLLATE NOCASE");
            ::MessagePlayer(COLOR_BLUE + "Your password has been set to " + COLOR_WHITE + password, player);
            ::FreeSQLQuery(q);
        }
    }

    function ToggleAutoLogin(player)
    {
        local q = ::QuerySQL(db, "SELECT * FROM accounts WHERE name='"+player.Name+"' COLLATE NOCASE");
        if(q)
        {
            local autologin = ::GetSQLColumnData(q, 3);
            if(autologin) {
                autologin = 0;
                ::MessagePlayer(COLOR_BLUE + "You have successfully turned auto login off. You will have to login manually on next join.", player);
            }
            else {
                autologin = 1;
                ::MessagePlayer(COLOR_BLUE + "You have successfully turned auto login on.", player);
            }
            ::QuerySQL(db, "UPDATE accounts SET autologin='"+autologin+"' WHERE name='"+player.Name+"' COLLATE NOCASE");
            ::FreeSQLQuery(q);
        }
    }

    function onPlayerJoin(player){
        if(IsRegistered(player)) {
            local q = ::QuerySQL(accounts.db, "SELECT * FROM accounts WHERE name='"+player.Name+"' COLLATE NOCASE");
            if(::GetSQLColumnData(q, 3) == 1) {
                if(player.UniqueID == ::GetSQLColumnData(q, 4) || player.UniqueID2 == ::GetSQLColumnData(q, 5)) {
                    AutoLogin(player);
                    ::MessagePlayer(::COLOR_YELLOW + "You have been auto logged in!", player);
                }
                else {
                    ::MessagePlayer(::COLOR_YELLOW + "This nick is registered. Use /login <password> to login to your account.", player);
                }
            }
            playerData[player.ID].registered = true;
            ::FreeSQLQuery(q);
        }
        else {
            ::MessagePlayer(::COLOR_RED + "This nick is not registered. Use /register <password> to register yourself.", player);
        }
    }

    function onPlayerPart(player) {
        accounts.LogOut(player);
    }
}

accounts <- Accounts();