#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Get the IED className the iedModule represents
 *
 * Arguments:
 * 0: Eden module <OBJECT>
 *
 * Return Value:
 * 0: IED className <STRING>
 *
 * Example:
 * [_logic] call rid_eden_fnc_getIEDModuleClass
 *
 * Public: [No]
 */
params["_module"];
TRACE_1("getIEDModuleClass",_module);

((_module get3DENAttribute QGVAR(iedCreation)) select 0) params [["_iedClassIndex", 0]];
private _cachedIEDItems = uiNamespace getVariable [QEGVAR(core,cachedIEDItems), []];

if ((count _cachedIEDItems) <= _iedClassIndex) exitWith {""};

(_cachedIEDItems select _iedClassIndex) select 1
