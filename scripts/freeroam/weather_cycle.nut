/*

File: weather_cycle.nut

Description: Changes the server weather every 5 mins.

*/

function changeWeather()
{
    switch(GetWeather())
    {
        case 0:
            SetWeather(1); break;
        case 1:
            SetWeather(2); break;
        case 2:
            SetWeather(5); break;
        case 4:
            SetWeather(0); break;
        case 5:
            SetWeather(4); break;
        default: // If the weather has been changed to foggy,snowy or dark by an admin.
            SetWeather(0); break;
    }
}


NewTimer("changeWeather", 4 * 60 * 1000, 0);