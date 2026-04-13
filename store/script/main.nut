// Sea Sparrow Variables
lb <- null;

// Speedometer Variables
speedometer <- null;
vehicle <- null;

screenX <- null;
screenY <- null;

::dofile("snow.nut");
::dofile("sniper.nut");

function Script::ScriptLoad()
{
	Hud.RemoveFlags(HUD_FLAG_WANTED)

	::snowEffect.PreloadItems();
}


function Script::ScriptProcess()
{
	::snowEffect.ProcessItems();
	::laser_sniper.proc();

	if(vehicle != null)
	{
		local x = ::pow(vehicle.Speed.X, 2);
		local y = ::pow(vehicle.Speed.Y, 2);
		local z = ::pow(vehicle.Speed.Z, 2);
		
		local speed = ::sqrt(x+y+z) * 180;
		speed = speed.tointeger();

		speedometer.Text = "Speed: " + speed + " km/h";
	}
}

function Server::ServerData(stream) {
    local data = stream.ReadByte();
	::screenX <- ::GUI.GetScreenSize().X;
	::screenY <- ::GUI.GetScreenSize().Y;

	if(data == 0x01) {
		local string = stream.ReadString();
		lb <- ::GUILabel( ::VectorScreen( screenX.tofloat() * 0.80 ,screenY.tofloat() * 0.33 ), ::Colour( 255, 153, 255), string );
		lb.FontSize = (x / 48);
		lb.FontName="pricedown";
		lb.FontFlags = GUI_FFLAG_OUTLINE | GUI_FLAG_TEXT_SHADOW;
	}
	if(data == 0x02)
	{
		lb <- null;
	}
	if(data == 0x03)
	{
		local v = stream.ReadInt();
		::vehicle <- ::World.FindVehicle(v);

		::speedometer <- ::GUILabel( ::VectorScreen( screenX.tofloat() * 0.012 , screenY.tofloat() * 0.68 ), ::Colour( 11, 210, 210), "Speed: 0 km/h");
		::speedometer.FontSize = (screenX / 48);
		::speedometer.FontName = "pricedown";
		::speedometer.FontFlags = GUI_FFLAG_OUTLINE | GUI_FLAG_TEXT_SHADOW;	
	}
	if(data == 0x04)
	{
		::speedometer <- null;
		::vehicle <- null;
	}
	if(data == 0x05)
	{
		::snowEffect.enabled <- true;
	}
	if(data == 0x06)
	{
		::snowEffect.enabled <- false;
	}
	if(data == 101)
	{
		::laser_sniper.on_server_data(stream);
	}
}

function GUI::GameResize(width, height)
{
	if(speedometer) {
		speedometer.Pos = VectorScreen(width.tofloat() * 0.012, height.tofloat() * 0.68);
		speedometer.FontSize = (width / 48);
	}
	if(lb) {
		lb.Pos = VectorScreen(width.tofloat() * 0.80, height.tofloat() * 0.33);
		lb.FontSize = (width / 48);
	}
}