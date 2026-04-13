/*

File: messages.nut

Description: Random messages to help players and give information about the game/server.

*/

messages <- 
[
    "Having low health? Go to a hospital or dispensary and heal yourself with /heal.",
    "Out of money? You can use health pickups for a slower heal!",
    "Complete Unique Stunt Jumps to win prizes!",
    "Have a look at the rules by /rules before playing.",
    "Visit Ammu-Nation to buy special weapons!",
    "Set your choices of weapons on spawn with /spawnwep",
    "Use /setconfig tag_maxdist 300 for a further nametag distance for sniping!",
    "Looking for a challange? Start a race with /startrace!",
    "Don't forget to add us to your favorites!",
];

function RandomMessage()
{
    Message(COLOR_PINK + "-> "+ messages[random(0, messages.len() - 1)]);
}

NewTimer( "RandomMessage", 75 * 1000, 0);