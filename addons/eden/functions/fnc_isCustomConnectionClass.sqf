#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Check if passed className is a custom connection class.
 *
 * Arguments:
 * 0: className <STRING>
 *
 * Return Value:
 * 0: Is custom connection className? <BOOLEAN>
 *
 * Example:
 * ["rid_eden_networkConnection"] call rid_eden_fnc_isCustomConnectionClass;
 *
 * Public: [No]
 */
params["_className"];

_className in ([true] call FUNC(getCustomConnectionClasses));
