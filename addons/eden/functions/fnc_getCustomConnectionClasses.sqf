#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Return customConnectionClassNames either from missionNamespace or compile them from the cache in uiNamespace.
 *
 * Arguments:
 * 0: return only classNames? <BOOLEAN>
 *
 * Return Value:
 * 0: customConnectionClasses or classNames <ARRAY>
 *
 * Example:
 * ["rid_eden_networkConnection"] call rid_eden_fnc_getCustomConnectionClasses;
 *
 * Public: [No]
 */
params [["_wantClassNames", false, [false]]];

private _classes = if !(isNil QGVAR(customConnectionClasses)) then {
    GVAR(customConnectionClasses)
} else {
    GVAR(customConnectionClasses) = call (uiNamespace getVariable [QGVAR(cacheCustomConnectionsClasses), {[]}]);
    GVAR(customConnectionClasses)
};

if (_wantClassNames) exitWith {_classes apply {_x select 0}};

_classes