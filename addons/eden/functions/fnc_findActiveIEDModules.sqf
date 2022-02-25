#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Return all active IED modules placed in the editor.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: Module Logics  <ARRAY>
 *
 * Example:
 * [] call rid_eden_fnc_findActiveIEDModules;
 *
 * Public: [No]
 */

private _logicObjects = all3DENEntities select 3;

_logicObjects select {typeOf _x == QGVAR(iedModule)};