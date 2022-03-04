#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Function for the rid_eden_iedModule.
 *
 * Arguments:
 * 0: Mode <STRING>
 * 1: Arguments dependant on Mode <ARRAY>
 *
 * Return Value:
 * true
 *
 * Example:
 * ["attributesChanged3DEN", _module] call rid_eden_fnc_iedModule
 *
 * Public: [No]
 */
params["_mode", "_args"];
TRACE_2("iedModule",_mode,_args);

switch _mode do {
    //Alternative to init, called from iedCreation attribute (see CfgVehicles) so we get acces to the attribute data.
    case "expression": {
        _args params ["_module", "_data"];
        _data params ["_iedClassIndex", "_triggerIndex"];
        TRACE_3("expression",_module,_iedClassIndex,_triggerIndex);

        private _cachedIEDItems = uiNamespace getVariable [QEGVAR(core,cachedIEDItems), []];
        if ((count _cachedIEDItems) <= _iedClassIndex) exitWith {};

        private _modulePositionATL = getPosATL _module;
        private _iedClass = (_cachedIEDItems select _iedClassIndex) select 1;
        private _triggerType = ["ext", "vib"] select _triggerIndex; //TODO make config defined

        private _ied = [_modulePositionATL, _iedClass, "standard", 3, _triggerType] call EFUNC(core,createIED);
        _ied setVectorDirAndUp [vectorDir _module, vectorUp _module];

        //Start replacing module by the IED
        //Map module objectID to IED
        private _moduleID = _module getVariable [QGVAR(objectID), -1];
        [_ied, _moduleID] call FUNC(registerObjectID);

        //Sync IED to Module Synced objects
        private _syncedObjects = synchronizedObjects _module;
        _ied synchronizeObjectsAdd _syncedObjects; 

        //Assign module variableName to IED (if any)
        private _moduleName = vehicleVarName _module;
        if (_moduleName isNotEqualTo "") then {
            _ied setVehicleVarName _moduleName;
            missionNamespace setVariable [_moduleName, _ied, true];
        };

        deleteVehicle _module;
    };
    //Called from preInit on Eden start
    case "edenStart": {
        _args params ["_module"];
        [_module] call FUNC(iedModuleAddGhostObject);
    };
    // When some attributes were changed (including position and rotation), Also fires when module is placed in Eden.
    case "attributesChanged3DEN": {
        _args params ["_module"];
        
        private _ghostIED = _module getVariable [QGVAR(ghostIED), objNull];

        if (isNull _ghostIED) then {
            [_module] call FUNC(iedModuleAddGhostObject);
        } else {
            private _iedClass = [_module] call FUNC(getIEDModuleClass);
            //IED class was changed
            if ((typeOf _ghostIED) isNotEqualTo _iedClass) then {
                deleteVehicle _ghostIED;
                [_module] call FUNC(iedModuleAddGhostObject);
            };
        };
    };
    // When object is being dragged
    case "dragged3DEN": {
        _args params ["_module"];
        
        private _ghostIED = _module getVariable [QGVAR(ghostIED), objNull];
        [_module, _ghostIED] call FUNC(iedModuleUpdateGhostObject);
    };
    // When removed from the world (i.e., by deletion or undoing creation)
    case "unregisteredFromWorld3DEN": {
        _args params ["_module"];
        
        //remove ghost IED if present
        private _ghostIED = _module getVariable [QGVAR(ghostIED), objNull];

        if !(isNull _ghostIED) then {
            deleteVehicle _ghostIED;
        };
    };
};
true