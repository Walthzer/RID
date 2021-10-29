#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * upon the deletion of a virtual IED conditionally delete its companion if it exists
 *
 * Arguments:
 * 0: virtualIED <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_virtualIED] call rid_core_fnc_onVirtualIEDDeletion;
 *
 * Public: [No]
 */
params["_virtualIED"];
TRACE_1("VirtualIED deleted:",_virtualIED);

private _ied = _virtualIED getVariable[QGVAR(ied), objNull];
private _deleteCompanionOnDeletion = _virtualIED getVariable[QGVAR(deleteCompanionOnDeletion), true];

if (!isNull _ied && {_deleteCompanionOnDeletion}) then {
	TRACE_1("Deleting Companion",_ied);
	deleteVehicle _ied;
};