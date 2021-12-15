#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Code that needs to be executed OnMissionLoad in EDEN.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * OnMissionSave = QUOTE(call rid_eden_fnc_onMissionSave);
 *
 * Public: [No]
 */

//Prevent Save Loop
if (GVAR(didResave)) exitWith {GVAR(didResave) = false};

//Update the storedConnections attribute of Eden entities to match it with active custom connections.
["RID Save Connections"] collect3DENHistory {

    QGVAR(attributes) set3DENMissionAttribute [QGVAR(storedConnections), call FUNC(findActiveConnections)];

    //No changes are unsaved anymore, reset so we default to saved connections. see rid_eden_fnc_getStoredConnections
    uiNamespace setVariable [QGVAR(previewConnections), []];

    //OnMMissionSave runs AFTER 3DEN saves the mission, resave to save the changes made by this script.
    GVAR(didResave) = true;
    do3DENAction "MissionSave";
};

