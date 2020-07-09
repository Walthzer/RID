#include "script_component.hpp"
//Turn screen and all indicators to off. Remove the minedetect eventhandler.

//mineDetected EH:
["ace_minedetector_mineDetected", GVAR(RscDetector_mindeDetectedEH)] call CBA_fnc_removeEventHandler;

private _detectorType = _unit getVariable [QGVAR(detectorType), ""];
if (currentWeapon ACE_player != _detectorType) exitWith {FUNC(deactivateRscDetector)};

_display = uiNamespace getVariable GVAR(displayRscDetector');
if (isNull _display) exitwith {diag_log "Is not display"};

//Turn screen off:
(_display displayCtrl 231001) ctrlSetText "MD_WD\Screen_OFF.paa";

//Set PWR indicators 
(_display displayCtrl 231109) ctrlSetTextColor [1, 1, 1, 0];
(_display displayCtrl 231209) ctrlSetTextColor [1, 1, 1, 0];

//Turn of remaining indicators:
[_display, 0] call FUNC(toggleRscDetector);

