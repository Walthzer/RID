#include "script_component.hpp"
#define TRACES_CONTROL 1894
/*
 * Create an IED at a given positionATL, set its defuse difficulty and attach the defuse action.
 * 
 * Arguments:
 * 0: Position <ASL> (ARRAY)
 * 1: Object to spawn <Classname> (STRING)
 * 2: Defuse Difficulty <0 - ACE standard 1 - PCB Standard 2 - PCB Difficult> (NUMBER)
 *
 * Return Value:
 * Created Object.
 *
 * Example:
 * [(getPosATL player),"IEDLandBig_F",1] call rid_core_fnc_createIED
 *
*/

params ["_position","_iedType","_difficulty","_trigger","_wires"];

//Validate _position value
if (typeName _position != "ARRAY") exitWith { ERROR("Position invalid") };
//Validate _iedType class exists
if (!isClass (configFile >> "CfgVehicles" >> _iedType)) exitWith { ERROR("iedType class Invalid") };

//Prepare variables
private _iedAmmo = getText (configFile >> "CfgVehicles" >> _iedType >> "ammo");
private _iedMagazine = getText (configFile >> "CfgAmmo" >> _iedAmmo >> "defaultMagazine");


//Action statement 
private _fnc_statement0 = {
    params["_target","_unit", "_pcb"];
    
    _unit action ["Deactivate", _unit, _target];
    
    missionNamespace setVariable [QGVAR(lookUpArray), (_pcb select 0)];
    missionNamespace setVariable [QGVAR(correctCuts), (_pcb select 1)];
    //Create the display.
    createDialog (_pcb select 2);
    _dialog = findDisplay 3300;
    _dialog setVariable [QGVAR(ied),_target];
    //Show previously cuts wires as such.
    {
        private _controlWire = (_dialog displayCtrl _x);
        _controlWire ctrlSetTextColor [1, 1, 1, 0];
    } forEach  (_target getVariable [QGVAR(cutWires),[]]);
    //Assign the path to the traces.paa selected.
    ctrlSetText [TRACES_CONTROL, (_pcb select 3)];
};

private _fnc_statement1 = {
    params["_target","_unit", "[_iedMagazine]"];
    
    _unit action ["Deactivate", _unit, _target];
    
    if (!(_target getVariable [QGVAR(defused),false])) exitWith {
        closeDialog 2;
        [_target] call FUNC(detonateIED);
    };
    private _weaponHolder = createVehicle ["Weapon_Empty", (getPosATL _target), [], 0, "CAN_COLLIDE"];
    deleteVehicle _target;
    _weaponHolder addMagazineCargo [_iedMagazine, 1];
    
};

//Action condition 
private _fnc_condition = {
    params["_target","_unit"];
    if (vehicle _unit != _unit || {!("ACE_DefusalKit" in ([_unit] call ace_common_fnc_uniqueItems))}) exitWith {false};
    if (ace_RequireSpecialist && {!([_unit] call ace_common_fnc_isEOD)}) exitWith {false};
    true;
};

//Prepare PCB
private _pcb = [_difficulty, _trigger, _wires] call FUNC(retrievePCB);

//Spawn IED
private _ied = createVehicle [_iedType, _position, [], 0, "CAN_COLLIDE"];

[_ied, FUNC(detonateIED), 0] call EFUNC(network,assignNetworkReciever);
[_ied, {{ _x addCuratorEditableObjects [[_this],true ] } forEach allCurators;}] remoteExec ["call", 2];

//Prepare and Attach functions
_action = ["Main","","", {}, _fnc_condition, {}, [], [0,0,0], 1] call ace_interact_menu_fnc_createAction;
[_ied, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Defuse","Defuse","z\ace\addons\explosives\UI\Defuse_ca.paa",_fnc_statement0, { true }, {}, _pcb, [0,0,0], 2] call ace_interact_menu_fnc_createAction;
[_ied, 0, ["Main"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Dig_up","Dig up","",_fnc_statement1, { true }, {}, [_iedMagazine], [0,0,0], 2] call ace_interact_menu_fnc_createAction;
[_ied, 0, ["Main"], _action] call ace_interact_menu_fnc_addActionToObject;

_ied;
