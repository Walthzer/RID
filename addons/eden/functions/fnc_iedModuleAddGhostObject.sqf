#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Create a ghost IED object on the iedModule dependant on the modules selected IED object.
 *
 * Arguments:
 * 0: iedModule <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_iedModule] call rid_eden_fnc_iedModuleAddGhostObject;
 *
 * Public: [No]
 */
params ["_module"];
TRACE_1("iedModuleAddGhostObject",_iedModule);

private _iedClass = [_module] call FUNC(getIEDModuleClass);
if (_iedClass isEqualTo "") exitWith {WARNING_1("Not adding ghostIED no valid class",_iedClass)};

private _ghostIED = createVehicle [_iedClass, [0,0,0]];
_module setVariable [QGVAR(ghostIED), _ghostIED];

[_module, _ghostIED] call FUNC(iedModuleUpdateGhostObject);