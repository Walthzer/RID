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
TRACE_5("Function start",_position,_iedType,_pcbType,_wires,_trigger);

if (_position isEqualTo [] || _iedType isEqualTo "" || _pcbType isEqualTo "" || _wires isEqualTo -1 || _trigger isEqualTo "") exitWith {ERROR("CreateIED: Bad argument")};

//Validate _iedType class exists
private _iedPath = configFile >> "CfgVehicles" >> _iedType;
if (!isClass (_iedPath)) exitWith { ERROR("iedType class Invalid") };

//Use new style of IED's or not
private _ied = objNull;
if (GVAR(useNonStaticIED)) then {
    private _ammo = getText(_iedPath >> "ammo");
    _iedObject = createVehicle [_ammo, _position, [], 0, "CAN_COLLIDE"]; //TODO: Allow random offset to bury the IED
    [_iedObject, false] call ACE_FUNC(explosives,allowDefuse);
    private _virtualIED = createVehicle ["rid_virtualIED", _position, [], 0, "CAN_COLLIDE"];
    _virtualIED setVariable [QGVAR(ied), _iedObject, true];

    _iedObject attachto [_virtualIED];
    _ied = _virtualIED;

    TRACE_3("NonStaticIED",_ammo,_ied,_virtualIED);
} else {
    _ied = createVehicle [_iedType, _position, [], 0, "CAN_COLLIDE"];
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