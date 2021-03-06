/*--------------------------------------------------*/
/* Startet eine über Ihren Index definierte Mission */
/*--------------------------------------------------*/
private["_zoneIndex"];
_zoneIndex = _this select 0;
/* Der "_missionInfoIndex" entspricht einmal dem Index der "pvehPixZones_MissionInfos" wo die Opt-Missions spezifischen Daten abgefragt */
/* werden können. Zum anderen entspricht er dem "pvehPixZones_MissionStatus" Index wo der Status der entsprechenden Mission hinterlegt ist */
private["_missionInfoIndex"];
_missionInfoIndex = _this select 1; 

/*--------------*/
/* Error Checks */
/*--------------*/
if (_zoneIndex < 0) then { player sidechat format["ERROR: Invalid MissionOpt-ZoneIndex %1 (too small)", _zoneIndex]; };
if (_zoneIndex >= pixZones_ZoneCount) then { player sidechat format["ERROR: Invalid MissionOpt-ZoneIndex %1 (too large)", _zoneIndex]; };

/*-----------------*/
/* Mission starten */
/*-----------------*/
private["_missionEnv"]; /* [missionIndex, missionPosition, missionDirection] */
_missionEnv = (pvehPixZones_MissionInfos select 1) select _missionInfoIndex; /* Das brauchen wir um an die env-mission-id (z.B. patrol, ...) zu kommen */

/*-----------------------------*/
/* Wichtig: Als execVM starten */
/*-----------------------------*/
_tmp = [_zoneIndex, _missionInfoIndex] execVM format["missionsEnv\%1\run.sqf", ((missionsEnv_Missions select (_missionEnv select 0)) select 0)];
