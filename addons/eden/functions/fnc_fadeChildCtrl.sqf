#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Toggels Disable and Fade on a list of ctrl's that are childen of a CT_CONTROLS_GROUP
 *
 * Arguments:
 * 0: CT_CONTROLS_GROUP <CONTROL>
 * 1: State to Achieve <NUMBER or BOOLEAN>
 * 2: IDC's <ARRAY of NUMBER>
 * Return Value:
 * None
 *
 * Example:
 * [_group, true, [102, 103]] call rid_eden_fnc_disableChildCtrl
 *
 * Public: [No]
 */
params["_parentGroup", "_state", "_arrIDC"];

private _fade = [0.75,0] select _state;
//private _disable = [false,true] select _state;

{
    private _ctrl = _parentGroup controlsGroupCtrl _x;
    //_ctrl ctrlEnable _disable;
    _ctrl ctrlSetFade _fade;
    _ctrl ctrlcommit 0;
} forEach _arrIDC;    