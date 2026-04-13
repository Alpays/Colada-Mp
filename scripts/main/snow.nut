/*

File: snow.nut

Description: Checks if snow weather is enabled by an admin.


*/

class Snow
{
    snowing = false;

    function onPlayerJoin(player)
    {
        if(snowing) {
            local str = Stream();
            str.StartWrite();
            str.WriteByte(STREAM_STARTSNOW);
            str.SendStream(player);
        }
    } 
}

snow <- Snow();