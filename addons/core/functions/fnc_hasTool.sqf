#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Check if a unit has a certain Tool Item
 *
 * Arguments:
 * 0: Unit <Object>
 * 1: Tool Item Name <STRING>
 *
 * Return Value:
 * unit has Tool <BOOLEAN>
 *
 * Example:
 * [ACE_player] call rid_core_fnc_canDefuse
 *
 * Public: [Yes]
 */
params["_unit","_tool"];


private _hasTool = (_tool in ([_unit] call ACE_FUNC(common,uniqueItems)));

TRACE_3("Unit has tool?",_unit,_tool,_hasTool);

_hasTool