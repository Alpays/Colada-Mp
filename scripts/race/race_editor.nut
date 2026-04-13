/*

File: race_editor.nut

Description: Race editor class.

*/

class RaceEditor
{
    active = false

    trackName = "null"
    author = "null"

    startingPos = null;
    startingAngle = null
    checkpoints = null;
    visCp = null;

    cpCount = 0
    maxCp = 100;

    vehicle = 145
    world = 2000;
    
    constructor()
    {
        checkpoints = array(0);
        visCp = array(0);
    }
    function reset()
    {
        for(local i = 0; i < checkpoints.len() - 1; ++i)
        {
            visCp[i].Remove();
        }

        // Reset the values to their default
        active = false 
        trackName = author = "null"
        startingPos = null;
        startingAngle = null 
        vehicle = 145    
        checkpoints = ::array(0)
        cpCount = 0
    }
}

raceEditor <- RaceEditor()