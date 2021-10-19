#include "script_component.hpp"
/*
* Author: Walthzer/Shark
* Attach the ACE interaction menu actions to an IED object. 
*
* Arguments:
* 0: IED <OBJECT>
*
* Return Value:
* None
*
* Example:
* [_ied] call rid_core_fnc_addIEDActions
*
* Public: [No]
*/
params["_ied"];

if (!hasInterface) exitWith {};

private _fnc_defuse = {
    params["_target", "_unit"];
    private _pcb = _target getVariable [QEGVAR(pcb,pcb), [] ];

    _unit action ["Deactivate", _unit, _target];

    if(_pcb isEqualTo []) exitWith {
        systemChat "Nothing to defuse";
    };
    uiNamespace setVariable[QEGVAR(pcb,ied), _target];
    createDialog (_pcb select 0 select 0);
    _dialog = findDisplay 3300;
    //Show previously cuts wires as such.
    {
        (_dialog displayCtrl _x) ctrlSetTextColor [1, 1, 1, 0];
        (_dialog displayCtrl _x) ctrlEnable false;
    } forEach  (_target getVariable [QEGVAR(pcb,cutWires), [] ]);
    //Assign the path to the traces.paa selected.
    ctrlSetText [1894, (_pcb select 0 select 4)];
};

private _fnc_dig = {
    params["_target", "_unit"];
    private _pcb = _target getVariable [QEGVAR(pcb,pcb), [] ];
    private _pcbParameters = _target getVariable [QEGVAR(pcb,pcbParameters), [] ];
    _unit action ["Deactivate", _unit, _target];

    private _exitCode = {};
    if(!(_pcb isEqualTo [])) then {
        //Detonate IED if Vibration detector still works:
        if(("vib" in (_pcbParameters select 2)) && (QEGVAR(pcb,hasPower) in (_pcb select 1)) && (QEGVAR(pcb,hasDetonator) in (_pcb select 1))) exitWith {_exitCode = {_target call EFUNC(core,detonateIED)}};

        //Inform player the IED is still connected:
        if(("ext" in (_pcbParameters select 2)) && (QEGVAR(pcb,hasExternal) in (_pcb select 1))) exitWith {
            _exitCode = {systemChat "The IED won't come loose, its still connected to something"}};
    };
    if(!(_exitCode isEqualTo {})) exitWith {call _exitCode};

    private _weaponHolder = createVehicle ["groundWeaponHolder", (getPosATL _target), [], 0, "CAN_COLLIDE"];
    private _iedAmmo = 0;
    
    if ((typeOf _target) == "rid_virtualIED") then {
        private _ied = _target getVariable QGVAR(ied);
        _iedAmmo = TypeOf _ied;
        TRACE_2("Dig up rid_virtualIED",_iedAmmo,_ied);
        deleteVehicle _ied;
    } else {
        _iedAmmo = getText (configFile >> "CfgVehicles" >> (TypeOf _target) >> "ammo");
        TRACE_1("Dig up IED",_iedAmmo,_target);
    };
    deleteVehicle _target;
    private _iedMagazine = getText (configFile >> "CfgAmmo" >> _iedAmmo >> "defaultMagazine");
    _weaponHolder addMagazineCargo [_iedMagazine, 1];
};

private _fnc_defuseCondition = {
    params["_target","_unit"];
    if (vehicle _unit != _unit || {!("ACE_DefusalKit" in ([_unit] call ace_common_fnc_uniqueItems))}) exitWith {false};
    if (ace_RequireSpecialist && {!([_unit] call ace_common_fnc_isEOD)}) exitWith {false};
    true;
};

private _fnc_digCondition = {
    params["_target","_unit"];
    if (vehicle _unit != _unit || {!("ACE_EntrenchingTool" in ([_unit] call ace_common_fnc_uniqueItems))}) exitWith {false};
    true;
};

private _mainCondition = {true};
if (rid_useNonStaticIED) then {
    _mainCondition = {[_target] call FUNC(validVirtualIEDCompanionExists)};
};

private _action = ["Main","","", {},_mainCondition, {}, [], [0,0,0], 1] call ace_interact_menu_fnc_createAction;
[_ied, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Defuse","Defuse","z\ace\addons\explosives\UI\Defuse_ca.paa",_fnc_defuse,_fnc_defuseCondition, {}, [], [0,0,0], 2] call ace_interact_menu_fnc_createAction;
[_ied, 0, ["Main"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Dig_up","Dig up","",_fnc_dig,_fnc_digCondition, {}, [], [0,0,0], 2] call ace_interact_menu_fnc_createAction;
[_ied, 0, ["Main"], _action] call ace_interact_menu_fnc_addActionToObject;