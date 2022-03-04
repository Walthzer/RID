#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Return Connections stored in either missionAttribute or uiNamespace, depending on if changes have been made since last save.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: storedConnections <ARRAY>
 *
 * Example:
 * [] call rid_eden_fnc_getStoredConnections;
 *
 * Public: [No]
 */

private _previewConnections = uiNamespace getVariable [QGVAR(previewConnections), []];

private _connections = if (_previewConnections isNotEqualTo []) then {
    _previewConnections
} else {
    [getMissionConfigValue QGVAR(storedConnections), QGVAR(attributes) get3DENMissionAttribute QGVAR(storedConnections)] select is3DEN;
};

_connections