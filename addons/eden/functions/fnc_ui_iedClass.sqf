#include "script_component.hpp"
/*
 * Author: Walthzer/Shark with thanks to ACE_Zeus
 * Initializes the "Create IED" Zeus module display.
 *
 * Arguments:
 * 0: iedClass controls group <CONTROL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [CONTROL] call rid_eden_fnc_ui_iedClass
 *
 * Public: [No]
 */
params["_controlGroup"];

// Generic Init
private _display = ctrlParent _controlGroup;
private _ctrlButtonOK = _display displayCtrl 1; //IDC_OK
private _module = missionNamespace getVariable [QUOTE(BIS_fnc_initCuratorAttributes_target), objNull];
TRACE_1("Module",_module);

//Initialize iedClass combo:
private _iedClassControl = _controlGroup controlsGroupCtrl 300001;
[_iedClassControl, uiNamespace getVariable [QEGVAR(core,cachedIEDItems), []]] call FUNC(comboAddItems);
_iedClassControl lbSetCurSel 0;

private _fnc_onUnload = {
    private _module = missionNamespace getVariable [QUOTE(BIS_fnc_initCuratorAttributes_target), objNull];
    if (isNull _module) exitWith {};

    deleteVehicle _module;
};

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];

    private _display = ctrlParent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _module = missionNamespace getVariable [QUOTE(BIS_fnc_initCuratorAttributes_target), objNull];
    if (isNull _module) exitWith {};
    
    private _iedClass = lbData [300001, lbCurSel 300001];
    if (_iedClass isEqualTo "") exitWith {};

    private _triggerType = lbData [300002, lbCurSel 300002];
    private _modulePositionATL = getPosATL _module;

    [_modulePositionATL, _iedClass, "standard", 3, _triggerType] call EFUNC(core,createIED);

    deleteVehicle _module;
};

_display displayAddEventHandler ["Unload", _fnc_onUnload];
_ctrlButtonOK ctrlAddEventHandler ["ButtonClick", _fnc_onConfirm];