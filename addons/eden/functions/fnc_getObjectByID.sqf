#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Use rid_eden_idMap HashMap to retrieve an Object by its Eden ID.
 *
 * Arguments:
 * 0: Eden ID <NUMBER>
 *
 * Return Value:
 * Object <OBJECT>
 *
 * Example:
 * [50] call rid_eden_fnc_getObjectByID
 *
 * Public: [No]
 */
params["_edenID"];
TRACE_1("Function start",_edenID);

GVAR(idMap) get _edenID;
