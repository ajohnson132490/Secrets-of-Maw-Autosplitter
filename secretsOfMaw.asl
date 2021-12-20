state("LittleNightmares", "steam")
{
	float xCoord : 0x33F9470, 0x30, 0x3C0, 0x160, 0x144;
	float yCoord : 0x33F9470, 0x30, 0x3C0, 0x160, 0x140;
	float zCoord : 0x33F9470, 0x30, 0x3C0, 0x160, 0x148;

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
if (current.xCoord == -13215 && current.levelID == 1 && current.levelTime > 0 && old.levelTime < 0.05 && !vars.runStarted) { vars.runStarted = true; } // Hack to make sure real time stays consistent with current rules
if (old.xCoord != -13215 && current.xCoord == -13215 && !vars.runStarted) { vars.AllGameTime = 0; } // Hack to make sure real time stays consistent with current rules

if (current.zCoord < 4000 && current.levelID == 7 && current.levelTime > 0 && old.levelTime < 0.05 && !vars.runStarted) { vars.AllGameTime = 0; vars.runStarted = true; } // Hack to make sure real time stays consistent with current rules
}

startup
{
settings.Add("split0", true, "Split at Chapter Change");
settings.Add("split1", true, "Split at Rope");
settings.Add("split2", true, "Split at Bread");
settings.Add("split3", true, "Split at Trap");
settings.Add("split4", true, "Split at Elevator");
settings.Add("split5", true, "Split at TV Room");
settings.Add("split6", false, "Split at Rat");
settings.Add("split7", true, "Split at Rafters");
settings.Add("split8", true, "Split at Freezer");
settings.Add("split9", true, "Split at Bottle");
}

start
{
	current.ropePassed = false;
	current.breadPassed = false;
	current.trapPassed = false;
	current.elevatorPassed = false;
	current.tvRoomPassed = false;
	current.ratPassed = false;
	current.raftersPassed = false;
	current.freezerPassed = false;
	current.bottlePassed = false;
	
	bool[] splitsTemp = new bool[95];
	vars.splits = splitsTemp; 

	vars.runStarted = false; // Hack to zero the timer due to using current rules Starting point not necessary with a proper start.
	
	vars.AllGameTime = 0;
//	return (current.xCoord == -13215 && current.levelID == 1 && current.levelTime > 0 && old.levelTime < 0.05);
	return ((old.xCoord == -13213 && current.xCoord != -13213 && current.levelID == 1) || (old.zCoord > 4000 && current.zCoord < 4000 && current.levelID == 7)); // Hack to zero the timer due to using current rules Starting point not necessary with a proper start.

}

split
{










if (current.levelID == 1) {

	current.ropePassed = current.xCoord > 21000;	
	if(!old.ropePassed && current.ropePassed && vars.splits[1] != true && settings["split1"]) {
   						vars.splits[1] = true;
						return true;
	}
	
	current.breadPassed = current.xCoord > 40000 && (old.ominousLight == 1063088292 || old.ominousLight == 1065353216) && current.ominousLight < 1065353216 && current.ominousLight > 1064933786;	
	if(!old.breadPassed && current.breadPassed && vars.splits[2] != true && settings["split2"]) {
   						vars.splits[2] = true;
						return true;
	}
	
} else if (current.levelID == 3) {

	current.trapPassed = old.zCoord < -6010 && current.zCoord > -4425 && current.zCoord < -4300;	
	if(!old.trapPassed && current.trapPassed && vars.splits[3] != true && settings["split3"]) {
   						vars.splits[3] = true;
						return true;
	}
	
	current.elevatorPassed = old.xCoord < -1180 && current.xCoord >= -1180 && current.yCoord > -325 && current.yCoord < 150  && current.zCoord < -5600 && current.zCoord > -6000 && (vars.splits[3] == true || !settings["split3"]);	
	if(!old.elevatorPassed && current.elevatorPassed && vars.splits[4] != true && settings["split4"]) {
   						vars.splits[4] = true;
						return true;
	}
	
	current.tvRoomPassed = current.xCoord <= 6840 && old.xCoord > 6840 && current.yCoord > -1400 && current.yCoord < -1000 && current.zCoord > 3240 && current.zCoord < 3450;
	if(!old.tvRoomPassed && current.tvRoomPassed && vars.splits[5] != true && settings["split5"]) {
   						vars.splits[5] = true;
						return true;
	}
	
} else if (current.levelID == 4) {

	current.ratPassed = current.xCoord > -14800 && (old.ominousLightRat == 1063088292 || old.ominousLightRat == 1065353216) && current.ominousLightRat < 1065353216 && current.ominousLightRat > 1063088292;	
	if(!old.ratPassed && current.ratPassed && vars.splits[6] != true && settings["split6"]) {
   						vars.splits[6] = true;
						return true;
	}

	current.raftersPassed = current.xCoord <= -5450 && old.xCoord > -5450 && current.yCoord > -1000 && current.yCoord < -600 && current.zCoord > 1800 && current.zCoord < 2200;	
	if(!old.raftersPassed && current.raftersPassed && vars.splits[7] != true && settings["split7"]) {
   						vars.splits[7] = true;
						return true;
	}
	
	current.freezerPassed = old.xCoord < 5550 && current.xCoord >= 5550 && current.yCoord > -500 && current.yCoord < 200 && current.zCoord > 130 && current.zCoord < 500;	
	if(!old.freezerPassed && current.freezerPassed && vars.splits[8] != true && settings["split8"]) {
   						vars.splits[8] = true;
						return true;
	}

} else if (current.levelID == 5) {

	current.bottlePassed = current.xCoord <= 2675 && old.xCoord > 2675 && current.yCoord > 0 && current.yCoord < 2000 && current.zCoord > 2000 && current.zCoord < 2700;	
	if(!old.bottlePassed && current.bottlePassed && vars.splits[9] != true && settings["split9"]) {
   						vars.splits[9] = true;
						return true;
	}

}


	return ((current.levelID > old.levelID && settings["split0"]) || (current.levelID == 6 && current.mirrorCounter == 6 && old.mirrorCounter != 6) || (current.levelID == 9 && old.xCoord != 11375 && current.xCoord == 11375 && current.zCoord < -2800));
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