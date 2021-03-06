/* ------------------------------------------------------------------------------------------------------------------------------
   Wird auf Server und Clienten aufgerufen, wenn die Variable "pvehPixZones_MissionInfos" sich �ndert.
   Sollte noch keine Missionen gestartet sein, dann werden diese nun gestartet. Ansonsten einfach nur die �nderungen ber�cksichtigt.
/* ------------------------------------------------------------------------------------------------------------------------------*/

if (str(pvehPixZones_MissionInfos) == "[]") then
{
	pixZones_ActiveIndex = -1;
}
else
{
	if (pixZones_ActiveIndex == -1) then
	{
		pixZones_ActiveIndex = pvehPixZones_MissionInfos select 0;
		
		private["_missionsEnv"];
		_missionsEnv = pvehPixZones_MissionInfos select 1;
		private["_missionsOpt"];
		_missionsOpt = pvehPixZones_MissionInfos select 2;

		/*----------------------*/
		/* Missions-Status erstellen  */
		/*----------------------*/
		if (isServer) then
		{
			pvehPixZones_MissionStatus = [];
			for "_i" from 0 to (count (pvehPixZones_MissionInfos select 2) - 1) do
			{
				pvehPixZones_MissionStatus = pvehPixZones_MissionStatus + [0];
			};
			/*--------------------------------*/
			/* An alle Clienten weiterreichen */
			/*--------------------------------*/
			publicVariable "pvehPixZones_MissionStatus";		
			if (!isDedicated) then	{ call compile preprocessFileLineNumbers "pixZones\pvehPixZones_MissionStatus.sqf"; }; /* PublicVariableEventHandler simulieren */
		};

		/*----------------------*/
		/* Env-Missions starten */
		/*----------------------*/
		for "_i" from 0 to ((count _missionsEnv) - 1) do
		{
			/* [zoneIndex, _missionInfoIndex] */
			[pixZones_ActiveIndex, _i] call compile preprocessFileLineNumbers "missionsEnv\run.sqf";
		};

		/*----------------------*/
		/* Opt-Missions starten */
		/*----------------------*/
		for "_i" from 0 to ((count _missionsOpt) - 1) do
		{
			/* [zoneIndex, _missionInfoIndex] */
			[pixZones_ActiveIndex, _i] call compile preprocessFileLineNumbers "missionsOpt\run.sqf";
		};
		

		/*----------------------------------------------------------------------------*/
		/* Der Server muss nun in der Schleife bleiben bis die Missionen vorbei sind. */
		/* Die Clienten dagegen k�nnen dieses Skript beenden. Die �berwachung der */
		/* einzelnen Missionen findet jeweils dort statt. */
		/*----------------------------------------------------------------------------*/
		if (isServer) then
		{
			/*---------------------------------------------*/
			/* Warten bis die Missionen abgeschlossen sind */	
			/*---------------------------------------------*/
			while { !call fn_pixZones_AllMissionsFinished } do
			{	
				Sleep 10;				
			};	
			
			/*----------------------------------------*/
			/* pvehPixZones_ZoneStatus aktualisieren  */
			/*----------------------------------------*/
			if (call fn_pixZones_AllMissionsSuccessfull) then
			{
				pvPixLogisticMoney = pvPixLogisticMoney + pixlogisticRewardForZone;
				{ if (_x >= 2) then { pvPixLogisticMoney = pvPixLogisticMoney + pixlogisticRewardForExistingZone;};	} foreach pvehPixZones_ZoneStatus;				
				publicVariable "pvPixLogisticMoney";
				
				pvehPixZones_ZoneStatus set [pixZones_ActiveIndex, 2];
				[] call compile preprocessFileLineNumbers "pixZones\serverSaveToDb.sqf";		
			}
			else
			{
				pvehPixZones_ZoneStatus set [pixZones_ActiveIndex, 0];
			};
			publicVariable "pvehPixZones_ZoneStatus";
			if (!isDedicated) then	{ call compile preprocessFileLineNumbers "pixZones\pvehPixZones_ZoneStatus.sqf"; }; /* PublicVariableEventHandler simulieren */
			
			pixZones_ActiveIndex = -1;
			pvehPixZones_MissionInfos = [];
			publicVariable "pvehPixZones_MissionInfos";
			if (!isDedicated) then	{ call compile preprocessFileLineNumbers "pixZones\pvehPixZones_MissionInfos.sqf"; }; /* PublicVariableEventHandler simulieren */
		};
	}
	else
	{
		/* Die "pvehPixZones_MissionInfos" Variable wurde aktualisiert. Wir m�ssen aber eigentlich nichts machen */
	};
};