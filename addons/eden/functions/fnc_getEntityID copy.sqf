#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Get objectID from Eden attribute
 *
 * Arguments:
 * 0: Eden Entity <OBJECT>
 *
 * Return Value:
 * ObjectID <number>
 *
 * Example:
 * [] call rid_eden_fnc_getEntityID
 *
 * Public: [No]
 */
params["_entity"];
TRACE_1("Function start",_entity);

(_entity get3DENAttribute QGVAR(objectID)) select 0;
