#include "script_component.hpp"
#include "\a3\3den\ui\resincl.inc"
#include "\a3\3den\ui\dikcodes.inc"


ADDON = false;

#include "XEH_PREP.hpp"

if (isServer) then {
    if (is3DEN) then {

        GVAR(didResave) = false;

        //Clean the Editor when we start on a different mission 
        if (!(isNil QGVAR(changedMission)) && {GVAR(changedMission)}) then {

            //No changes are unsaved anymore, reset so we default to saved connections. see rid_eden_fnc_getStoredConnections
            uiNamespace setVariable [QGVAR(previewConnections), []];
        };
        
        //If this is a clean start of the Eden Display, add our EH's.
        if (!(uiNamespace getVariable [QGVAR(hasAddedUiEHs), false])) then {
            
            private _edenDisplay = findDisplay IDD_DISPLAY3DEN;

            //Mark Eden display as cleared if it unloads. 
            _edenDisplay displayAddEventHandler ["Unload", {
                uiNamespace setVariable [QGVAR(hasAddedUiEHs), false];
                false
            }];

            //Catch player pressing the bottom-left play button.
            (_edenDisplay displayCtrl IDC_DISPLAY3DEN_PLAY) ctrlAddEventHandler ["MouseButtonDown", {
                call FUNC(onPreview);
                false
            }];

            //Change the Menu Strip Play actions so they call onPreview before the BIS function and stop their engine behaviour.
            private _menuStrip = _edenDisplay displayCtrl IDC_DISPLAY3DEN_MENUSTRIP;
            for "_i" from 0 to (_menuStrip menuSize [6]) do {
                private _path = [6, _i];
                private _data = _menuStrip menuData _path;

                //Only seperator Items do not have any data defined, skip if we are on a seperator
                if (_data isEqualTo "") then {continue};

                private _action = _menuStrip menuAction _path;

                //Create an action that emulates engine behaviour if Item doesn't have an action.
                if (_action isEqualTo "") then {
                    _action = format [QUOTE(do3DENAction '%1';), _data];
                };

                //Prepend onPreview function to Item action.
               _menuStrip menuSetAction [_path, QUOTE(call FUNC(onPreview);) + _action];

               //Delete Item data to prevent Engine from overriding us.
               _menuStrip menuSetData [_path, ""];
            };

            uiNamespace setVariable [QGVAR(hasAddedUiEHs), true];
        };

        //Connections need to be restored upon Eden Interface load.
        [call FUNC(getStoredConnections)] call FUNC(restoreStoredConnections);

    } else {
        if (isNil QGVAR(idMap)) then {
            GVAR(idMap) = createHashMap;
        };
    };
};

ADDON = true;
