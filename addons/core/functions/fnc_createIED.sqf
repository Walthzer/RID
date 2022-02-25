#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Create an IED and selects a PCB minigame fitting to given arguments. 
 * Should the only provided trigger be external, it will keep the IED "dumb" until a network link to it is made.
 *
 * Arguments:
 * 0: PositionATL <ARRAY>
 * 1: CfgAmmo OR CfgVehicles className <STRING>
 * 2: PCB Type <STRING>
 * 3: Wires <INTEGER>
 * 4: Trigger Type <STRING>
 *
 * Return Value:
 * Created IED <OBJECT>
 *
 * Example:
 * [[0,0,0], "IEDLandSmall_Remote_Ammo", "standard", 3, "ext"] call rid_core_fnc_createIED
 *
 * Public: [Yes]
 */
private _validArgs = params[["_positionATL", [], [[]]], ["_iedClassname", "", [""]], ["_pcbType", "", [""]], ["_wires", -1, [0]], ["_trigger", "", [""]]];
TRACE_5("Function start",_positionATL,_iedClassname,_pcbType,_wires,_trigger);

if !(_validArgs) exitWith {ERROR("CreateIED: Bad argument")};

private _isCfgAmmo = isClass (configFile >> "CfgAmmo" >> _iedClassname);
if !(_isCfgAmmo || {isClass (configFile >> "CfgVehicles" >> _iedClassname)}) exitWith {ERROR("CreateIED: Invalid IED Classname")};

private _ied = if (_isCfgAmmo) then {
    _iedObject = createVehicle [_iedClassname, _positionATL, [], 0, "CAN_COLLIDE"];
    [_iedObject, false] call ACE_FUNC(explosives,allowDefuse);

    private _virtualIED = createVehicle ["rid_virtualIED", _positionATL, [], 0, "CAN_COLLIDE"];
    _virtualIED setVariable [QGVAR(ied), _iedObject, true];

    _iedObject attachto [_virtualIED];
    _virtualIED;

} else {
    createVehicle [_iedClassname, _positionATL, [], 0, "CAN_COLLIDE"];
};

["ace_zeus_addObjects", [[_ied]]] call CBA_fnc_serverEvent;

_ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbType, _wires, _trigger], true];

//Assign IED a pcb minigame
if(_trigger != "ext") then {
    _pcb = [_ied, _pcbType, _wires, _trigger] call EFUNC(pcb,retrievePCB);
    _ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbType, _wires, _trigger], true];
    _ied setVariable [QEGVAR(pcb,pcb), _pcb, true];
    if ("vib" in _trigger && {isNull (_ied getVariable[QGVAR(vibrationDetector), objNull])}) then {
        TRACE_1("Assigning Vibration Detector to IED",_ied);
        [QGVAR(createVibrationDetector), [_ied, true]] call CBA_fnc_serverEvent;
    };
    TRACE_1("IED minigame assigned",_ied,_pcb);
};

_fnc_addExtTrigger = {
    private _ied = (_this select 2)#0;
    private _pcbParameters = _ied getVariable [QEGVAR(pcb,pcbParameters), []];

    if (_pcbParameters isEqualTo []) exitWith {ERROR("Updating IED with ext trigger failed, bad argument(s)")};

    if(count (_ied getVariable [QEGVAR(pcb,pcb), []]) > 0) then {
        private _compositeTrigger = format["ext%1", _pcbParameters select 2];
        private _pcb = [_ied, _pcbParameters select 0, _pcbParameters select 1, _compositeTrigger] call EFUNC(pcb,retrievePCB);
        _ied setVariable [QEGVAR(pcb,pcb), _pcb, true];
        _ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbParameters select 0, _pcbParameters select 1, _compositeTrigger], true];
    } else {
        private _pcb = [_ied, _pcbParameters select 0, _pcbParameters select 1, "ext"] call EFUNC(pcb,retrievePCB);
        _ied setVariable [QEGVAR(pcb,pcbParameters), [_pcbParameters select 0, _pcbParameters select 1, "ext"], true];
        _ied setVariable [QEGVAR(pcb,pcb), _pcb, true];
    };
    _ied setVariable[QEGVAR(network,onNewLinkCode), {}, true];
};

//Allow addition of ext trigger if network connection to IED is made.
[_ied, _fnc_addExtTrigger, [_ied]] call EFUNC(network,createNetworkNode);
[_ied, FUNC(detonateIED)] call EFUNC(network,assignNetworkReciever);

//Attach ACE actions to IED:
[
    [QGVAR(addIEDActions), [_ied]] call CBA_fnc_globalEventJIP,
    _ied
] call CBA_fnc_removeGlobalEventJIP;
_ied;