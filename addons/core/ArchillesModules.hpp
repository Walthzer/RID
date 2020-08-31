["RID", "Spawn IED",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    private _dialogResult =
    [
        "Specify IED",
        [
            // The last number is optional! If you want the first selection you can remove the number.
            ["IED Type:", ["Large IED (Dug-In)","Small IED (Dug-In)","Large IED (Urban)","Small IED (Urban)"]],
            ["Internal trigger:", ["No","Vibration detector"]]
            //["Vibration detector tuning:", ["Men", "Wheeled vehicles", "Tracked vehicles"]]
            
        ]
        //rid_core_fnc_RscDisplayAttributes_createIED"
    ] call Ares_fnc_showChooseDialog;
    
    if (_dialogResult isEqualTo []) exitWith {};
    
    private _iedType = switch (_dialogResult select 0) do {
        
        case 0: { "IEDLandBig_F" };
        case 1: { "IEDLandSmall_F" };
        case 2: { "IEDUrbanBig_F" };
        case 3: { "IEDUrbanSmall_F" };
    };

    private _trigger = ["ext", "vib"] select (_dialogResult select 1);
    [_position, _iedType, "standard", 3, _trigger] call FUNC(createIED);
}] call Ares_fnc_RegisterCustomModule;

["RID", "Create Network Link",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    private _fnc_showInstructions = {
        sleep 0.1;
        [["Realistic_IED_Defusal_Zeus","NetworkLink"],15,"not isNil ""Achilles_var_submit_selection""",35,"not isNil ""Achilles_var_submit_selection""",true,true] call BIS_fnc_advHint;
    };
    
    if (not (isNull _objectUnderCursor) and (_objectUnderCursor getVariable["rid_network_isNetworkNode", false])) then {
        private _primaryNode = _objectUnderCursor;
        [] spawn _fnc_showInstructions;
        private _secundaryNode = ["Objects", true] call Achilles_fnc_SelectUnits;
        if (isNil "_secundaryNode") exitWith {};
        if (not (_secundaryNode getVariable["rid_network_isNetworkNode", false])) exitWith {["Connection canceled: Object was not network node"] call Achilles_fnc_showZeusErrorMessage};
        [_primaryNode, _secundaryNode, true] call rid_network_fnc_createNetworkLink;
        
    } else {
        if (true) exitWith {["Connection canceled: Object was not network node"] call Achilles_fnc_showZeusErrorMessage};
    };

    if (isNull _objectUnderCursor) then {
        private _primaryNode = [_position] call rid_network_fnc_createNetworkNode;
        [] spawn _fnc_showInstructions;
        private _secundaryNode = ["Objects", true] call Achilles_fnc_SelectUnits;
        if (isNil "_secundaryNode") exitWith {};
        if (not (_secundaryNode getVariable["rid_network_isNetworkNode", false])) exitWith {["Connection canceled: Object was not network node"] call Achilles_fnc_showZeusErrorMessage};
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
    [_objectUnderCursor, _thresholdMass] remoteExecCall [QFUNC(createPressurePlate), 2];
}] call Ares_fnc_RegisterCustomModule;

["RID", "Create Vibration Detector",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    if (isNull _objectUnderCursor) exitWith {};
    
    [_objectUnderCursor] remoteExecCall [QFUNC(createVibrationDetector), 2];
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
        [_primaryNode, _secundaryNode, _tripWireHeight] remoteExecCall [QFUNC(createRIDTripwire), 2];
        
    } else {
        if (true) exitWith {["Tripwire canceled: no object selected"] call Achilles_fnc_showZeusErrorMessage};
    };
}] call Ares_fnc_RegisterCustomModule;

["RID", "Spawn Detonator Box",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    if ((not (_position isEqualTo [])) && isNull _objectUnderCursor) then {
        private _box = createVehicle ["rid_wireDetonator", _position, [], 0, "CAN_COLLIDE"];
        [_box, {{ _x addCuratorEditableObjects [[_this],true ] } forEach allCurators;}] remoteExec ["call", 2];
    };
}] call Ares_fnc_RegisterCustomModule;

