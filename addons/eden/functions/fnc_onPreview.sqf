#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Code that needs to be executed BEFORE Eden changes into preview mode.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call rid_eden_onPreview;
 *
 * Public: [No]
 */
diag_log ["PRE-PREVIEW"];

["RID Preview Connections"] collect3DENHistory {

    uiNamespace setVariable [QGVAR(previewConnections), call FUNC(findActiveConnections)];

};