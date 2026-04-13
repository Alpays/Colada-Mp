/*

File: vehicles_nut

Description: Database of vehicles on the city.

*/

function onScriptLoad() {
    vehicles.db = ConnectSQL("vehicles.db");
    QuerySQL(vehicles.db, "CREATE TABLE IF NOT EXISTS vehicles(id INTEGER PRIMARY KEY AUTOINCREMENT, model INTEGER, x FLOAT, y FLOAT, z FLOAT, angle FLOAT, color1 INTEGER, color2 INTEGER)");

    loadVehicles();
}

function onScriptUnload()
{
    DisconnectSQL(vehicles.db);
}

function loadVehicles()
{
    local vehcount = 0;
    local q = QuerySQL( vehicles.db, "SELECT * FROM vehicles");
    if(q) {
        while(GetSQLColumnData(q, 0)) {
            local model = GetSQLColumnData(q, 1);
            local x = GetSQLColumnData(q, 2);
            local y = GetSQLColumnData(q, 3);
            local z = GetSQLColumnData(q, 4);
            local angle = GetSQLColumnData(q, 5);
            local col1 = GetSQLColumnData(q, 6);
            local col2 = GetSQLColumnData(q, 7);
            local v = CreateVehicle( model, 1, Vector(x,y,z), angle, col1, col2);
            v.RespawnTimer = (3 * 60000);
            if(v.Model == 207) {
                v.SetHandlingData(29, -2); //orange front
                v.SetHandlingData(30, -6); //orange rear
            }
            GetSQLNextRow(q);
            ++vehcount;
        }
        FreeSQLQuery(q);
    }
    if(vehcount > 0)
    {
        print(vehcount + " vehicles have been loaded from vehicle database.");
    }
    else print("No vehicles were found in the database. You can add some using /addvehicle (Requires Admin Level 3)");
}

