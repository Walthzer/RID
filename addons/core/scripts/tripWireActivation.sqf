/*
 * Hats of to VKing from the ACE Team, absolute godtier technique to attach SQF to the triggering of a tripwire.
 *
 * beforeDestroyScript friendly function calling of rid_fnc_tripWireActivation.
 *
 * Arguments:
 * 0: Position <ARRAY>
 *
 * Return Value:
 * None
 *
 */

// This is called from a CfgCloudlet's beforeDestroyScript config.
// It will be re-compiled each use, so avoid complex preProcessor includes and just call the prepared function.

[rid_core_fnc_tripWireActivation, _this] call CBA_fnc_directCall;