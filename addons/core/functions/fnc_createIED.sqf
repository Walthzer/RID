#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Create an IED and selects a PCB minigame fitting to given arguments. 
 * Should the only provided trigger be external, it will keep the IED "dumb" until a network link to it is made.
 *
 * Arguments:
 * 0: Position <ARRAY>
 * 1: IED Type <STRING>
 * 2: PCB Type <STRING>
 * 3: Wires <INTEGER>
 * 4: Trigger Type <STRING>
 *
 * Return Value:
 * Created IED <OBJECT>
 *
 * Example:
 * [[0,0,0], "IEDLandBig_F", "standard", 3, "ext"] call rid_core_fnc_createIED
 *
 * Public: [Yes]
 */
params[["_position", [], [[]]], ["_iedType", "", [""]], ["_pcbType", "", [""]], ["_wires", -1, [0]], ["_trigger", "", [""]]];

if (_position isEqualTo [] || _iedType isEqualTo "" || _pcbType isEqualTo "" || _wires isEqualTo -1 || _trigger isEqualTo "") exitWith {ERROR("CreateIED: Bad argument")};

//Validate _iedType class exists
if (!isClass (configFile >> "CfgVehicles" >> _iedType)) exitWith { ERROR("iedType class Invalid") };

private _ied = createVehicle [_iedType, _position, [], 0, "CAN_COLLIDE"]; //TODO: Allow random offset to bury the IED
_ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbType, _wires, _trigger], true];
[_ied, {{ _x addCuratorEditableObjects [[_this],true ] } forEach allCurators;}] remoteExec ["call", 2];

//Assign IED a pcb minigame
if(_trigger != "ext") then {
    _pcb = [_ied, _pcbType, _wires, _trigger] call EFUNC(pcb,retrievePCB);
    _ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbType, _wires, _trigger], true];
    _ied setVariable [QEGVAR(pcb,pcb), _pcb, true];
    if("vib" in _trigger && {isNull (_ied getVariable[QGVAR(vibrationDetector), objNull])}) then {
        [_ied, true] remoteExecCall [QFUNC(createVibrationDetector), 2];
    };
};

_fnc_addExtTrigger = {
    params["_ied"];
    private _pcbParameters = _ied getVariable [QEGVAR(pcb,pcbParameters), []];
    if (_pcbParameters isEqualTo []) exitWith {ERROR("Updating IED with ext trigger failed, bad argument(s)")};
    if(count (_ied getVariable [QEGVAR(pcb,pcb), []]) > 0) then {
        private _compositeTrigger = format["ext%1", _pcbParameters#2];
        private _pcb = [_ied, _pcbParameters#0, _pcbParameters#1, _compositeTrigger] call EFUNC(pcb,retrievePCB);
        _ied setVariable [QEGVAR(pcb,pcb), _pcb, true];
        _ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbParameters#0, _pcbParameters#1, _compositeTrigger], true];
    } else {
        private _pcb = [_ied, _pcbParameters#0, _pcbParameters#1, "ext"] call EFUNC(pcb,retrievePCB);
        _ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbParameters#0, _pcbParameters#1, "ext"], true];
        _ied setVariable [QEGVAR(pcb,pcb), _pcb, true];
    };
	_ied setVariable[QEGVAR(network,onNewLinkCode), {}, true];
};

//Allow addition of ext trigger if network connection to IED is made.
[_ied, _fnc_addExtTrigger] call EFUNC(network,createNetworkNode);
[_ied, FUNC(detonateIED)] call EFUNC(network,assignNetworkReciever);

//Add ace interaction:
private _fnc_defuse = {
    params["_target", "_unit"];
    private _pcb = _target getVariable [QEGVAR(pcb,pcb), []];

    _unit action ["Deactivate", _unit, _target];

    if(_pcb isEqualTo []) exitWith {
        systemChat "Nothing to defuse";
    };
    uiNamespace setVariable[QEGVAR(pcb,ied), _target];
    createDialog ((_pcb#0)#0);
    _dialog = findDisplay 3300;
    //Show previously cuts wires as such.
    {
        (_dialog displayCtrl _x) ctrlSetTextColor [1, 1, 1, 0];
        (_dialog displayCtrl _x) ctrlEnable false;
    } forEach  (_target getVariable [QEGVAR(pcb,cutWires), []]);
    //Assign the path to the traces.paa selected.
    ctrlSetText [1894, ((_pcb#0)#4)];
};

private _fnc_dig = {
    params["_target", "_unit"];
    private _pcb = _target getVariable [QEGVAR(pcb,pcb), []];
    private _pcbParameters = _target getVariable [QEGVAR(pcb,pcbParameters), []];
	_unit action ["Deactivate", _unit, _target];

	private _exitCode = {};
	if(!(_pcb isEqualTo [])) then {
		//Detonate IED if Vibration detector still works:
		if(("vib" in (_pcbParameters#2)) && (QEGVAR(pcb,hasPower) in (_pcb#1)) && (QEGVAR(pcb,hasDetonator) in (_pcb#1))) exitWith {_exitCode = {_target call EFUNC(core,detonateIED)}};

		//Inform player the IED is still connected:
		if(("ext" in (_pcbParameters#2)) && (QEGVAR(pcb,hasExternal) in (_pcb#1))) exitWith {_exitCode = {systemChat "The IED won't come loose, its still connected to something"}};
	};
	if(!(_exitCode isEqualTo {})) exitWith {call _exitCode};

    private _weaponHolder = createVehicle ["Weapon_Empty", (getPosATL _target), [], 0, "CAN_COLLIDE"];
    deleteVehicle _target;
    private _iedAmmo = getText (configFile >> "CfgVehicles" >> (TypeOf _target) >> "ammo");
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

//Prepare and Attach functions
_action = ["Main","","", {}, {true}, {}, [], [0,0,0], 1] call ace_interact_menu_fnc_createAction;
[_ied, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Defuse","Defuse","z\ace\addons\explosives\UI\Defuse_ca.paa",_fnc_defuse,_fnc_defuseCondition, {}, [], [0,0,0], 2] call ace_interact_menu_fnc_createAction;
[_ied, 0, ["Main"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Dig_up","Dig up","",_fnc_dig,_fnc_digCondition, {}, [], [0,0,0], 2] call ace_interact_menu_fnc_createAction;
[_ied, 0, ["Main"], _action] call ace_interact_menu_fnc_addActionToObject;

_ied;