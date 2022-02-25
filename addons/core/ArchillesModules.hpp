//Check if Achilles is loaded:
if (isClass(configFile >> "CfgPatches" >> "achilles_data_f_achilles")) then {
INFO("RID: Achilles modules loaded!");

["RID", "Create Network Link",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    private _fnc_showInstructions = {
        sleep 0.1;
        [["Realistic_IED_Defusal_Zeus","NetworkLink"],15,"not isNil ""Achilles_var_submit_selection""",35,"not isNil ""Achilles_var_submit_selection""",true,true] call BIS_fnc_advHint;
    };
    
    if (not (isNull _objectUnderCursor)) then {
        if ([_objectUnderCursor] call FUNC(isCfgAmmoInstance)) then {
            _objectUnderCursor = [_objectUnderCursor] call FUNC(getVirtualIEDFromCompanion);
        };
        if (_objectUnderCursor getVariable["rid_network_isNetworkNode", false]) then {
            private _primaryNode = _objectUnderCursor;
            [] spawn _fnc_showInstructions;
            private _secundaryNode = ["Objects", true] call Achilles_fnc_SelectUnits;
            if (isNil "_secundaryNode") exitWith {};
            if (not ([_secundaryNode] call EFUNC(network,isNetworkNode))) exitWith {["Connection canceled: Object was not network node"] call Achilles_fnc_showZeusErrorMessage};
            [_primaryNode, _secundaryNode, true] call rid_network_fnc_createNetworkLink;
            
        } else {
            if (true) exitWith {["Connection canceled: Object was not network node"] call Achilles_fnc_showZeusErrorMessage};
        };
    };

    if (isNull _objectUnderCursor) then {
        private _primaryNode = [_position] call rid_network_fnc_createNetworkNode;
        [] spawn _fnc_showInstructions;
        private _secundaryNode = ["Objects", true] call Achilles_fnc_SelectUnits;
        if (isNil "_secundaryNode") exitWith {};
        if (not ([_secundaryNode] call EFUNC(network,isNetworkNode))) exitWith {["Connection canceled: Object was not network node"] call Achilles_fnc_showZeusErrorMessage};
        [_primaryNode, _secundaryNode, true] call rid_network_fnc_createNetworkLink;
    };
}] call Ares_fnc_RegisterCustomModule;

["RID", "Create Pressure Plate",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    if (isNull _objectUnderCursor) exitWith {};
    
    private _dialogResult =
    [
        "Setup Pressure Plate",
        [
            ["Threshold mass:", "", "110"],
            ["Mass reference:", "MESSAGE", "Man: 100 kg.\nMan with full kit: 140 kg.\nHumvee: 3500kg"]
        ]
    ] call Ares_fnc_showChooseDialog;
    
    if (_dialogResult isEqualTo []) exitWith {};
    
    _thresholdMass = parseNumber(_dialogResult select 0);
    [QGVAR(createPressurePlate), [_objectUnderCursor, _thresholdMass]] call CBA_fnc_serverEvent;
}] call Ares_fnc_RegisterCustomModule;

["RID", "Create Tripwire",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    private _fnc_showInstructions = {
        sleep 0.1;
        [["Realistic_IED_Defusal_Zeus","Tripwire"],15,"not isNil ""Achilles_var_submit_selection""",35,"not isNil ""Achilles_var_submit_selection""",true,true] call BIS_fnc_advHint;
    };
    
    if (not (isNull _objectUnderCursor)) then {
        private _primaryNode = _objectUnderCursor;
        [] spawn _fnc_showInstructions;
        private _secundaryNode = ["Objects", true] call Achilles_fnc_SelectUnits;
        if (isNil "_secundaryNode") exitWith {};
        
        private _dialogResult =
        [
            "Setup Tripwire",
            [
                ["Tripwire height:", "", "1"],
                ["Mass reference:", "MESSAGE", "Knee high: 0.6"]
            ]
        ] call Ares_fnc_showChooseDialog;
        
        if (_dialogResult isEqualTo []) exitWith {};
        
        _tripWireHeight = parseNumber(_dialogResult select 0);
        [_primaryNode, _secundaryNode, _tripWireHeight] call FUNC(createRIDTripwire);
        
    } else {
        if (true) exitWith {["Tripwire canceled: no object selected"] call Achilles_fnc_showZeusErrorMessage};
    };
}] call Ares_fnc_RegisterCustomModule;

["RID", "Spawn Vibration Detector",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    if ((not (_position isEqualTo [])) && isNull _objectUnderCursor) then {
        private _box = createVehicle ["rid_wireBox_vibrationDetector", _position, [], 0, "CAN_COLLIDE"];
        ["ace_zeus_addObjects", [[_box]]] call CBA_fnc_serverEvent;
    };
}] call Ares_fnc_RegisterCustomModule;

["RID", "Spawn Detonator Box",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    if ((not (_position isEqualTo [])) && isNull _objectUnderCursor) then {
        private _box = createVehicle ["rid_wireDetonator", _position, [], 0, "CAN_COLLIDE"];
        ["ace_zeus_addObjects", [[_box]]] call CBA_fnc_serverEvent;
    };
}] call Ares_fnc_RegisterCustomModule;
};
