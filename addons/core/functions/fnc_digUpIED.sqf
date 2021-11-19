#include "script_component.hpp"
/*
* Author: Walthzer
* Initiate the removal of an IED object and drop it as an item or make it explode dependig on the trigger it has.
*
* Arguments:
* 0: IED <OBJECT>
*
* Return Value:
* None
*
* Example:
* [_ied] call rid_core_fnc_digUpIED
*
* Public: [No]
*/
params["_target"];
TRACE_2("Function start",_target);

private _pcb = _target getVariable [QEGVAR(pcb,pcb), [] ];
private _pcbParameters = _target getVariable [QEGVAR(pcb,pcbParameters), [] ];

private _exitCode = {};
if(!(_pcb isEqualTo [])) then {
    //Detonate IED if Vibration detector still works:
    if(("vib" in (_pcbParameters select 2)) && (QEGVAR(pcb,hasPower) in (_pcb select 1)) && (QEGVAR(pcb,hasDetonator) in (_pcb select 1))) exitWith {_exitCode = {_target call EFUNC(core,detonateIED)}};

    //Inform player the IED is still connected:
    if(("ext" in (_pcbParameters select 2)) && (QEGVAR(pcb,hasExternal) in (_pcb select 1))) exitWith {
        _exitCode = {systemChat (LLSTRING(StillConnected))}};
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

