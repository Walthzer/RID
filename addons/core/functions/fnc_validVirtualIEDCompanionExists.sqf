#include "script_component.hpp"
/*
* Author: Walthzer/Shark
* Used to check if an IED helper (Virtual IED) has a valid companion IED.
*
* Arguments:
* 0: VIRTUAL IED <OBJECT>
*
* Return Value:
* companion Exists <BOOLEAN>
*
* Example:
* [_virtualIED] call rid_core_fnc_validVirtualIEDCompanionExists
*
* Public: [No]
*/
params["_virtualIED"];

private _ied = _virtualIED getVariable [QGVAR(ied), objNull];

!IsNull _ied