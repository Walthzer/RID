#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Update the position and rotation of a iedModule's Ghost IED.
 *
 * Arguments:
 * 0: iedModule <OBJECT>
 * 1: ghost ied <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_iedModule] call rid_eden_fnc_iedModuleUpdateGhostObject;
 *
 * Public: [No]
 */
params ["_module", "_ghostIED"];
TRACE_2("iedModuleUpdateGhostObject",_module,_iedClass);

if (isNull _ghostIED) exitWith {ERROR_1("No ghostIED to update",_ghostIED)};

//Postion
private _modulePosATL = getPosATL _module;
_ghostIED setPosATL _modulePosATL;

//Handel surface snap when enabled
if ((get3DENActionState "SurfaceSnapToggle") == 1) then {
    _ghostIED setVectorUp (surfaceNormal _modulePosATL);
} else {
	//Rotation
    _ghostIED setVectorDirAndUp [vectorDir _module, vectorUp _module];
};
