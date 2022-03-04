#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Adds passed items into the passed control.
 *
 * Arguments:
 * 0: Combo <CONTROL>
 * 1: List of items <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_comboCtrl, cachedIEDItems] call rid_eden_fnc_comboAddItems;
 *
 * Public: [No]
 */
params["_ctrl", "_itemsArray"];
TRACE_2("comboAddItems",_ctrl,_itemsArray);

{
    _x params ["_text", "_data", ["_picture", ""], ["_modIcon", ""]];

    private _itemRow = _ctrl lbAdd _text;
    _ctrl lbSetData [_itemRow, _data];
    _ctrl lbSetPicture [_itemRow, _picture];
    _ctrl lbSetPictureRight [_itemRow, _modIcon];
    
} forEach _itemsArray;