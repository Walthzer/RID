#define COLOR_VALID_SELECTION [0, 0.9, 0, 1]
#define COLOR_INVALID_SELECTION [0.9, 0, 0, 1]

//Check if Zeus Enhanced is loaded:
if (isClass(configFile >> "CfgPatches" >> "zen_main")) then {
INFO("RID: Zeus Enhanced modules loaded!");

["RID", "Spawn IED",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    _position = ASLToATL _position;
    [
        "Specify IED",
        [
            ["COMBO", "IED Type:", [["IEDLandBig_F", "IEDLandSmall_F", "IEDUrbanBig_F", "IEDUrbanSmall_F"], ["Large IED (Dug-In)","Small IED (Dug-In)","Large IED (Urban)","Small IED (Urban)"]]],
            ["COMBO", "Internal trigger:", [["ext", "vib"], ["No","Vibration detector"]]]
            
        ],
        {[(_this select 1), (_this select 0)#0, "standard", 3, (_this select 0)#1] call FUNC(createIED)},
        {},
        _position
    ] call zen_dialog_fnc_create;
}] call zen_custom_modules_fnc_register;

["RID", "Create Network Link",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    _position = ASLToATL _position;

    private _primaryNode = objNull;
    private _exit = false;

    if (isNull _objectUnderCursor) then {
        _primaryNode = [_position] call EFUNC(network,createNetworkNode);
    } else {
        if (_objectUnderCursor getVariable["rid_network_isNetworkNode", false]) then {
            _primaryNode = _objectUnderCursor;
        } else {
            _exit = true;
        };
    };

    if (_exit) exitWith {["Connection canceled: Object was not network node"] call zen_common_fnc_showMessage};

    if (not (isNull _primaryNode)) then {
        [["Realistic_IED_Defusal_Zeus","NetworkLink"],15,"not zen_common_selectPositionActive",35,"not zen_common_selectPositionActive",false,true] call BIS_fnc_advHint;
        [_primaryNode,
        {
            params ["_succesFull", "_primaryNode"];

            if (not _succesFull) exitWith {};

            curatorMouseOver params ["_type", "_secundaryNode"];
            if (isNil "_secundaryNode") exitWith {};

            if (not (_secundaryNode getVariable["rid_network_isNetworkNode", false])) exitWith {["Connection canceled: Object was not network node"] call zen_common_fnc_showMessage};
            [_primaryNode, _secundaryNode, true] call rid_network_fnc_createNetworkLink;
        },
        [],
        "Secundary Node",
        "\a3\ui_f\data\igui\cfg\cursors\select_target_ca.paa",
        45,
        COLOR_INVALID_SELECTION,
        {   
            params ["_object"];
            curatorMouseOver params ["_type", "_node"];

            if (isNil "_node" || {_node == _object || (not (_node getVariable["rid_network_isNetworkNode", false]))}) exitWith {
                _this select 3 set [3, COLOR_INVALID_SELECTION];
            };

            _this select 3 set [3, COLOR_VALID_SELECTION];
        }
        ] call zen_common_fnc_selectPosition;
    };

}] call zen_custom_modules_fnc_register;

["RID", "Create Pressure Plate",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    
    if (isNull _objectUnderCursor) exitWith {};
    
    [
        "Setup Pressure Plate",
        [
            ["EDIT", ["Threshold mass:", format ["Man: 100 kg.%1Man with full kit: 140 kg.%1Humvee: 3500kg", endl]], [100, {str (parseNumber _this)}]]
        ],
        {
            private _threshold = parseNumber ((_this select 0)#0);
            [QGVAR(createPressurePlate), [_objectUnderCursor, _thresholdMass]] call CBA_fnc_serverEvent;
            ["Detector Created!"] call zen_common_fnc_showMessage;
        },
        {},
        _objectUnderCursor
    ] call zen_dialog_fnc_create;
}] call zen_custom_modules_fnc_register;

["RID", "Create Tripwire",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];

    if (not (isNull _objectUnderCursor)) then {
        [["Realistic_IED_Defusal_Zeus","Tripwire"],15,"not zen_common_selectPositionActive",35,"not zen_common_selectPositionActive",false,true] call BIS_fnc_advHint;
        [_objectUnderCursor,
        {
            params ["_succesFull", "_object"];

            if (not _succesFull) exitWith {};

            curatorMouseOver params ["_type", "_secundaryNode"];
            if (isNil "_secundaryNode") exitWith {["Tripwire canceled: no second object selected"] call zen_common_fnc_showMessage};

            [
                "Setup Tripwire",
                [
                    ["SLIDER", ["Tripwire height:","Knee high: 0.6"], [0, 50, 1, 0]]
                ],
                {
                    [(_this select 1)#0, (_this select 1)#1, (_this select 0)#0] call FUNC(createRIDTripwire);
                },
                {},
                [_object, _secundaryNode]
            ] call zen_dialog_fnc_create;
        },
        [],
        "Second Object",
        "\a3\ui_f\data\igui\cfg\cursors\select_target_ca.paa",
        45,
        COLOR_INVALID_SELECTION,
        {   
            params ["_object"];
            curatorMouseOver params ["_type", "_node"];

            if (isNil "_node" || {_node == _object}) exitWith {
                _this select 3 set [3, COLOR_INVALID_SELECTION];
            };
            _this select 3 set [3, COLOR_VALID_SELECTION];
        }
        ] call zen_common_fnc_selectPosition;
        
    } else {
        if (true) exitWith {["Tripwire canceled: no object selected"] call zen_common_fnc_showMessage};
    };
}] call zen_custom_modules_fnc_register;

["RID", "Spawn Vibration Detector",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    _position = ASLToATL _position;

    if ((not (_position isEqualTo [])) && isNull _objectUnderCursor) then {
        private _box = createVehicle ["rid_wireBox_vibrationDetector", _position, [], 0, "CAN_COLLIDE"];
        ["ace_zeus_addObjects", [[_box]]] call CBA_fnc_serverEvent;
    };
}] call zen_custom_modules_fnc_register;

["RID", "Spawn Detonator Box",
{
    // Get all the passed parameters
    params [["_position", [0,0,0], [[]], 3], ["_objectUnderCursor", objNull, [objNull]]];
    _position = ASLToATL _position;

    if ((not (_position isEqualTo [])) && isNull _objectUnderCursor) then {
        private _box = createVehicle ["rid_wireDetonator", _position, [], 0, "CAN_COLLIDE"];
        ["ace_zeus_addObjects", [[_box]]] call CBA_fnc_serverEvent;
    };
}] call zen_custom_modules_fnc_register;
};
