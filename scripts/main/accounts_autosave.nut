/*

File: accounts_autosave.nut

Description: Auto save accounts every minute.

*/

function AutoSave() {
    for(local i = 0; i < GetMaxPlayers(); ++i) {
        if(GetPlayer(i)) {
            accounts.SaveData(GetPlayer(i).ID);
        }    
    }
}

NewTimer("AutoSave", 60 * 1000, 0);