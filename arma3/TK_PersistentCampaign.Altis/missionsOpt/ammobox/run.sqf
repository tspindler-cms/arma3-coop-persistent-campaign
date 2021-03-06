private["_zoneIndex"];
_zoneIndex = _this select 0;
private["_missionInfoIndex"];
_missionInfoIndex = _this select 1;

/*----------------------------------*/
/* Die Missionsdaten herausarbeiten */
/*----------------------------------*/
private["_missionOpt"]; /* [missionIndex, missionPosition, missionStatus] */
_missionOpt = ((pvehPixZones_MissionInfos select 2) select _missionInfoIndex);
private["_missionPosition"];
_missionPosition = _missionOpt select 1;

/*---------------------------------------*/
/* Wenn notwendig die Clientside starten */
/*---------------------------------------*/
if (!isServer || !isDedicated) then
{
	private["_tmp"];
	_tmp = [_missionInfoIndex, _missionPosition] execVM "missionsOpt\ammobox\runClient.sqf";	
};

if (isServer) then
{
	private["_units"];
	_units = [];
	
	
	private["_ammobox1"];
	_ammobox1 = "Box_East_WpsSpecial_F" createVehicle _missionPosition;
	_ammobox1 setdir random 360;
	_ammobox1 setVectorUp surfaceNormal (position _ammobox1);
	_units = _units + [_ammobox1];

	private["_ammobox2"];
	_ammobox2 = "Box_East_WpsSpecial_F" createVehicle _missionPosition;
	_ammobox2 setdir random 360;
	_ammobox2 setVectorUp surfaceNormal (position _ammobox2);
	_units = _units + [_ammobox2];
	

	private["_spawnGroup"];
	private["_randomPos"];
	private["_random"];
	_random = floor (random 3) + 1;
	for "_i" from 0 to _random do 
	{
		_randomPos = [[[_missionPosition, random 600 + 300]],["water","out"]] call BIS_fnc_randomPos;
		private["_spawnGroup"];
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		nul = [_spawnGroup, _missionPosition, random 600 + 300] call fn_missionsOpt_Patrol;
		_units = _units + (units _spawnGroup);
		 [_spawnGroup] call fn_missionsOpt_SetSkill;
	};

	_random = floor (random 2) + 1;
	for "_i" from 0 to _random do 	
	{
		_randomPos = [[[_missionPosition, random 80]],["water","out"]] call BIS_fnc_randomPos;
		_spawnGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam")] call BIS_fnc_spawnGroup;
		[_spawnGroup, _missionPosition] call BIS_fnc_taskDefend;
		_units = _units + (units _spawnGroup);
		 [_spawnGroup] call fn_missionsOpt_SetSkill;
	};

	_ammobox1 setDamage 0.5;
	_ammobox2 setDamage 0.5;
	if (_ammobox1 distance [0,0,0] < 1000) then { _ammobox1 setDamage 1;};
	if (_ammobox2 distance [0,0,0] < 1000) then { _ammobox2 setDamage 1;};
	
	/*--------------------------------------*/
	/* Warten bis die Mission erfüllt wurde */
	/*--------------------------------------*/
	waitUntil {((!alive _ammobox1) && (!alive _ammobox2)) || (pixZones_ActiveIndex == -1)};
	
	/*--------------------------------------------------------*/
	/* Status auf beendet setzen und allen Clienten mitteilen */
	/*--------------------------------------------------------*/
	if (pixZones_ActiveIndex != -1) then
	{
		pvehPixZones_MissionStatus set [_missionInfoIndex, 1]; /* erfolgreich */	
	}
	else
	{	
		pvehPixZones_MissionStatus set [_missionInfoIndex, 2]; /* Fehlgeschlagen */
	};
	publicVariable "pvehPixZones_MissionStatus";
	if (!isDedicated) then { call compile preprocessFileLineNumbers "pixZones\pvehPixZones_MissionStatus.sqf"; }; /* PublicVariableEventHandler simulieren */


	/*-----------------------*/
	/* Kurze Zeitverzögerung */
	/*-----------------------*/
	if (pixDebug) then
	{
		sleep 60;
	}
	else
	{
		sleep 10;
	};

	/*------------------------*/
	/* Alle Einheiten löschen */
	/*------------------------*/
	{deletevehicle _x} foreach _units;
};