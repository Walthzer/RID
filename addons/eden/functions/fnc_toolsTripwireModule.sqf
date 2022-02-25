#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Create a tripwireModule between two selected eden entities.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call rid_eden_fnc_toolsTripwireModule;
 *
 * Public: [No]
 */
(flatten (get3DENSelected "")) params [["_entity0", objNull, [objNull]], ["_entity1", objNull, [objNull]]];

["RID Create Tripwire"] collect3DENHistory {
	private _modulePosition = [[_entity0, _entity1]] call FUNC(calculateObjectsCenter);
	private _module = create3DENEntity ["Logic", QGVAR(tripwireModule), _modulePosition];
	
	[_module, [_entity0, _entity1]] call FUNC(tripwireModuleInitialize);
};
