#include "script_component.hpp"
/*
 * Create a tripwire between two object at a set height.
 *
 * Arguments:
 * 0: Node <OBJECT>
 * 1: Node <OBJECT>
 * 2: Wire height <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [8481:Empty.p3d, 4852:IEDLandSmall_F.p3d] call rid_core_fnc_createRIDTripwire;
 *
*/
params["_object0", "_object1", "_height"];

//Confirm the arguments are objects
if (not (IS_OBJECT(_object0) and IS_OBJECT(_object1))) exitWith {ERROR_2("%1 and %2 are not objects!", _object0, _object1)};

//Create a tripwirePart: an 1m segment of tripwire and an empty helper:
private _fnc_createPart = {
    params["_position", "_vector", "_tripwirePartsIndex"];

    //Create the helper:
    private _helper = createVehicle ["rid_tripWire_helper", (ASLToATL _position), [], 0, "CAN_COLLIDE"];
    _helper setVariable [QGVAR(tripWireNodes), [_object0, _object1], true];


    //Give the helper the Index to the position where the tripwire it is part of is stored in _object0's rid_tripwire_parts ARRAY, to allow rid_core_fnc_tripWireActivation to clean up the tripwire:
    _helper setVariable [QGVAR(tripwire_parts_index), _tripwirePartsIndex, true];

    //Spawn the tripwire segment:
    private _segment = createVehicle ["rid_tripWire_segment_ammo", (ASLToATL _position), [], 0, "CAN_COLLIDE"];

    //Do setVectorDir on the segement for ever player locally and new players if the tripWire still exists when they join.
    private _eventHandlerId = [QGVAR(fixVector), [_segment, _vector]] call CBA_fnc_globalEventJIP;
    [_eventHandlerId, _segment] call CBA_fnc_removeGlobalEventJIP;

    [_segment, _helper];
};

_fnc_spawnWireBox = {
    (_this#2) params ["_object", "_height"];
    if (!(_object getVariable [QGVAR(wireBox), objNull] isEqualTo objNull)) exitWith {};
    private _bbr = boundingBoxReal _object;
    private _relPos = _object modelToWorld [((_bbr#0)#0 + (_bbr#1)#0)/2,(_bbr#0)#1, (_bbr#0)#2];

    private _position = [_relPos#0, _relPos#1, _height];
    private _wireBox = createVehicle ["rid_wireBox", _position, [], 0, "CAN_COLLIDE"];
    [_wireBox, _object] call BIS_fnc_attachToRelative;

    _wireBox setVectorDir (vectorDir _object);
    _wireBox setPosATL _position;

    _wirebox setVariable[QGVAR(master), _object, true];
    _object setVariable[QGVAR(isConnected), true, true];
    _object setVariable[QGVAR(wireBox), _wireBox, true];

    //Delete wireBox when oject is deleted:
    _object addEventHandler ["Deleted", {
	    params ["_entity"];
	    deleteVehicle (_entity getVariable [QGVAR(wireBox), objNull]);
    }];
};
//Setup _object0 as a networkNode
[_object0, _fnc_spawnWireBox, [_object0, _height]] call EFUNC(network,createNetworkNode);

//Designate a space in the rid_tripwire_parts array of _object0 and retrieve the index of said space:
private _existingTripwiresParts = _object0 getVariable [QGVAR(tripwires_parts),[]];
private _tripwirePartsIndex = _existingTripwiresParts pushBack [];
_object0 setVariable [QGVAR(tripwires_parts), _existingTripwiresParts, true];

[_object1, _object0] call BIS_fnc_attachToRelative;

//Create fysical tripwire:
private _object0Pos = (getPosATL _object0);
private _x0 = (_object0Pos select 0);
private _y0 = (_object0Pos select 1);

private _object1Pos = (getPosATL _object1);
private _x1 = (_object1Pos select 0);
private _y1 = (_object1Pos select 1);

_object0Pos set [2, 0];
_height = ((ATLToASL _object0Pos) select 2) + _height;

private _nodesCenter = [(_x0 + _x1)/2, (_y0 + _y1)/2, _height];

private _distanceBetweenNodes = (_object0 distance2D _object1);
private _directionVector = _object0Pos vectorFromTo _object1Pos;

private _tripwireParts = [];
private _tripWirePartsAmount = ceil _distanceBetweenNodes;

switch (true) do {

    //Should distance between objects be smaller than 1m, spawn a single segment at the median point:
    case(_tripWirePartsAmount == 1): {
        private _tripWirePartPos = _nodesCenter;
        private _tripWirePart = [_tripWirePartPos, _directionVector, _tripwirePartsIndex] call _fnc_createPart;
        _tripwireParts pushBack (_tripWirePart select 0);
        _tripwireParts pushBack (_tripWirePart select 1); 
    };
    
    //When distance is above 1m, spawn parts until the last full meter:
    case(_tripWirePartsAmount > 1): {
        private _tripWirePartPos = [];
        for "_i" from 1 to (_tripWirePartsAmount - 1) do {
            private _offset = _i - 0.5;
            _tripWirePartPos = (_object0Pos vectorAdd ( _directionVector vectorMultiply (_offset)));
            _tripWirePartPos set [2, _height];
            private _tripWirePart = [_tripWirePartPos, _directionVector, _tripwirePartsIndex] call _fnc_createPart;

            _tripwireParts pushBack (_tripWirePart select 0);
            _tripwireParts pushBack (_tripWirePart select 1); 
        };
        //Fill up the space between the last segment and _object1 by clipping a segement in the last created segment, filling up the remainder.
        _tripWirePartPos = (_tripWirePartPos vectorAdd ( _directionVector vectorMultiply (1 + (_distanceBetweenNodes - _tripWirePartsAmount))));
        private _tripWirePart = [_tripWirePartPos, _directionVector, _tripwirePartsIndex] call _fnc_createPart;
        
        _tripwireParts pushBack (_tripWirePart select 0);
        _tripwireParts pushBack (_tripWirePart select 1); 
    };
};

//Store the parts of this tripwire in the _object0, to allow tripwire clean up:
private _existingTripwiresParts = _object0 getVariable [QGVAR(tripwires_parts),[]];
_existingTripwiresParts set [_tripwirePartsIndex, _tripwireParts];
_object0 setVariable [QGVAR(tripwires_parts), _existingTripwiresParts, true];

//Delete tripwire when oject is deleted:
_object0 addEventHandler ["Deleted", {
	params ["_entity"];
	_entity call FUNC(defuseTripWire);
}];