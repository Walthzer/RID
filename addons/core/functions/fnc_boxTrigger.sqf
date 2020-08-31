#include "script_component.hpp"
/*
 * Box Trigger activation handler
 * 
 * Arguments:
 * 0: Triggerbox <OBJECT>
 *
 * Return Value:
 * Detonation succes <BOOLEAN>
 *
 * Example:
 * [_target] call rid_core_fnc_boxTrigger
 *
 * Public: [Yes]
*/
params["_box"];

If(_box getVariable['rid_core_isConnected', false]) then {
	[_box] spawn EFUNC(network,activateNetworkCrawler);
};