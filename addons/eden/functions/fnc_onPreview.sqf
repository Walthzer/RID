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
MESSAGE_WITH_TITLE("RID","PRE-PREVIEW");

["RID Cached Mission Data"] collect3DENHistory {
    //Custom Connections
        uiNamespace setVariable [QGVAR(previewConnections), call FUNC(findActiveConnections)];
    //---------
};