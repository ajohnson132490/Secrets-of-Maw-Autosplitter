state("LittleNightmares", "steam")
{
	float xCoord : 0x33F9470, 0x30, 0x3C0, 0x160, 0x144;
	float yCoord : 0x33F9470, 0x30, 0x3C0, 0x160, 0x140;
	float zCoord : 0x33F9470, 0x30, 0x3C0, 0x160, 0x148;

	//Currently Unused
	int firstStatue : 0x000004B0, 0x298, 0xFC8, 0xDA8, 0x50, 0x0, 0x910;

	int ominousLight : 0x34104F8, 0x7A8, 0x8, 0x118, 0x160, 0xDC;
	int ominousLightRat : 0x34104F8, 0x7A8, 0x8, 0x118, 0xD8, 0xDC;

	float levelTime : 0x34104F8, 0x40, 0x4A4;
	int levelID : 0x317B940, 0x1C8, 0x74;
	int mirrorCounter : 0x3400148, 0x0, 0x2C0, 0x188, 0xF8;
}
state("LittleNightmares", "gog")
{
	float xCoord : 0x33FA480, 0x30, 0x3C0, 0x160, 0x144;
	float yCoord : 0x33FA480, 0x30, 0x3C0, 0x160, 0x140;
	float zCoord : 0x33FA480, 0x30, 0x3C0, 0x160, 0x148;

	//Currently Unused
	int firstStatue : 0x000014C0, 0x298, 0xFC8, 0xDA8, 0x50, 0x0, 0x910;

	int ominousLight : 0x3411508, 0x7A8, 0x8, 0x118, 0x160, 0xDC;
	int ominousLightRat : 0x3411508, 0x7A8, 0x8, 0x118, 0xD8, 0xDC;

	float levelTime : 0x3411508, 0x40, 0x4A4;
	int levelID : 0x317C940, 0x1C8, 0x74;
	int mirrorCounter : 0x3401158, 0x0, 0x2C0, 0x188, 0xF8;
}

init
{
if (modules.First().ModuleMemorySize == 0x36AC000) { version = "gog"; } else if (modules.First().ModuleMemorySize == 0x36AB000) { version = "steam"; }
bool[] splitsTemp = new bool[95];
vars.splits = splitsTemp;
vars.runStarted = false; // Hack to make sure real time stays consistent with current rules.
}

update
{
if (current.zCoord < 4000 && current.levelID == 7 && current.levelTime > 0 && old.levelTime < 0.05 && !vars.runStarted) { vars.AllGameTime = 0; vars.runStarted = true; } // Hack to make sure real time stays consistent with current rules

print("First Statue: " + current.firstStatue);
}

startup
{
settings.Add("split0", true, "Split at Level Change");
settings.Add("split1", true, "Split at Washer");
settings.Add("split2", true, "Split at Ladder");
settings.Add("split3", true, "Split at Boiler Room");
settings.Add("split4", true, "Split at Elevator");
settings.Add("split5", true, "Split at Cart Smash");
settings.Add("split6", false, "Split at First Statue");
settings.Add("split7", true, "Split at Eye Puzzle Door ");
settings.Add("split8", true, "Split at Piano Room");
}

start
{
	//Timer stuff
	bool[] splitsTemp = new bool[95];
	vars.splits = splitsTemp;

	vars.runStarted = false; // Hack to zero the timer due to using current rules Starting point not necessary with a proper start.
	vars.AllGameTime = 0;

	return (old.zCoord > 4000 && current.zCoord < 4000 && current.levelID == 7); // Hack to zero the timer due to using current rules Starting point not necessary with a proper start.

}

split
{
	//Split when you hit the water after the out of bounds skip [DEPTHS]
	if (current.levelID == 7 && settings["split1"] && vars.splits[1] != true && current.zCoord > -7000 && current.zCoord < -6700
	 && current.xCoord < -9500 && current.xCoord > -10500 ) {
		 vars.splits[1] = true;
		return true;
	}
		//Split at first ladder [DEPTHS]
		else if (current.levelID == 7 && vars.splits[1] == true && settings["split2"] && vars.splits[2] != true && current.zCoord > -6330
		&& current.xCoord > 13300) {
			vars.splits[2] = true;
			return true;
		}

		//Split when you enter the boiler room [HIDEAWAY]
		else if (current.levelID == 8  && vars.splits[2] == true && settings["split3"] && vars.splits[3] != true
		&& current.xCoord > -2375.0	&& current.zCoord > 110) {
			vars.splits[3] = true;
			return true;
		}

		//Split when Elevator goes down [HIDEAWAY]
		else if (current.levelID == 8  && vars.splits[3] == true && settings["split4"] && vars.splits[4] != true && current.yCoord < 780
		 && old.zCoord > current.zCoord && current.zCoord < 765 && current.zCoord > 600) {
			vars.splits[4] = true;
			return true;
		}

		//Split at Cart Smash [HIDEAWAY]
		else if (current.levelID == 8 && vars.splits[4] == true && settings["split5"] && vars.splits[5] != true && old.xCoord < current.xCoord
		&& current.xCoord > -4345 && current.zCoord > 970) {
			vars.splits[5] = true;
			return true;
		}


		/*
		//Split at first Statue [RESIDENCE]
		if (current.firstStatue > old.firstStatue) {
		return true;
	}
	*/

		//Split at the Eye Puzzle door [RESIDENCE]
		else if (current.levelID == 9 && vars.splits[5] == true && settings["split7"] && vars.splits[7] != true && current.xCoord > 882 && current.zCoord > 1660) {
			vars.splits[7] = true;
			return true;
		}

		//Split at Piano Room
		else if (current.levelID == 9 && vars.splits[7] && settings["split8"] && vars.splits[8] != true && current.xCoord > -4500
		&& current.zCoord > 919 && current.zCoord < 1000) {
			vars.splits[8] = true;
			return true;
		}


	//Split at Level changes
	return (current.levelID > old.levelID && settings["split0"]);
}

reset
{
	return (current.levelID == 0 && old.levelID != 0);
}

isLoading
{
	return true;
}

gameTime
{
	if (old.levelTime > current.levelTime) { vars.AllGameTime += old.levelTime; }
	if (current.levelTime >= 0 && vars.runStarted) { return TimeSpan.FromSeconds(vars.AllGameTime+current.levelTime); } else if (!vars.runStarted) { return TimeSpan.FromSeconds(0); }
}
