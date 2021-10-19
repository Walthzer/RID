#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Gets the Companion virtualIED of the passed IED Object
 *
 * Arguments:
 * 0: IED <Object>
 *
 * Return Value:
 * virtualIED <OBJECT>
 *
 * Example:
 * [_ied] call rid_core_fnc_getVirtualIEDFromCompanion
 *
 * Public: [No]
 */
params["_ied"];

private _iedPos = getPosATL _ied;
private _virtualIED = nearestObject [_iedPos, "rid_virtualIED"];

if (isNull _virtualIED || {(_ied distance _virtualIED) > MaxVirtualIEDDistance}) exitwith {
null
};
_virtualIED