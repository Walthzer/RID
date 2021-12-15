#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Inserts an Object into the rid_eden_idMap at its Eden ID position to provide a lookup table from (Eden ID -> Object).
 * Also gives the object a variable that holds it EdenID.
 *
 * Arguments:
 * 0: Object <OBJECT>
 * 1: Eden ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this,50] call rid_eden_fnc_registerObjectID
 *
 * Public: [No]
 */
params["_object", "_edenID"];
TRACE_2("Function start",_object,_edenID);

GVAR(idMap) set [_edenID, _object];
SETVAR(_object,GVAR(objectID),_edenID);
