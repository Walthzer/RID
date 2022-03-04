#include "script_component.hpp"
/*
 * Create a tripwire between two object at a certein height.
 *
 * Arguments:
 * 0: Node <OBJECT>
 * 1: Node <OBJECT>
 * 2: Height object OR Offset from ground <OBJECT OR NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [8481:Empty.p3d, 4852:IEDLandSmall_F.p3d, 1.3] call rid_core_fnc_createRIDTripwire;
 *
*/
params[["_object0", objNull, [objNull]], ["_object1", objNull, [objNull]], ["_heightArg", 1, [0, objNull]]];
TRACE_3("createRIDTripwire",_object0,_object1,_heightArg);

//Confirm the arguments are objects
if (isNull _object0 or isNull _object1) exitWith {ERROR_2("%1 and %2 are null", _object0, _object1)};

private _distanceBetweenNodes = (_object0 distance2D _object1);
private _object0Pos = getPosASL _object0;
private _directionVector =  _object0Pos vectorFromTo (getPosASL _object1);

//Tripwire height, either height of an object or offset from ground.
private _heightASL = if (IS_OBJECT(_heightArg)) then {
    (getPosASL _heightArg) select 2
} else {
    (_object0Pos select 2) + _heightArg
};


//Create a tripwirePart: an 1m segment of tripwire and an empty helper:
private _fnc_createPart = {
    params["_position", "_vector", "_tripwirePartsIndex"];

    //Create the helper:
    private _helper = createVehicle ["rid_tripwire_helper", (ASLToATL _position), [], 0, "CAN_COLLIDE"];
    _helper setVariable [QGVAR(tripWireNodes), [_object0, _object1], true];


    //Give the helper the Index to the position where the tripwire it is part of is stored in _object0's rid_tripwire_parts ARRAY, to allow rid_core_fnc_tripWireActivation to clean up the tripwire:
    _helper setVariable [QGVAR(tripwire_parts_index), _tripwirePartsIndex, true];

    //Spawn the tripwire segment:
    private _segment = createVehicle ["rid_tripWire_segment_ammo", (ASLToAGL _position), [], 0, "CAN_COLLIDE"];
    
    //Work around for preInit. PR a fix in ACE
    if (isNil "ace_explosives_excludedMines") then {
        GVAR(excludedMines) pushBackUnique _segment;
    } else {
        private _EHId = ["ace_allowDefuse", [_segment, false]] call CBA_fnc_globalEventJIP;
        [_EHId, _segment] call CBA_fnc_removeGlobalEventJIP;
    };
    
    //Do setVectorDir on the segement for ever player locally and new players if the tripWire still exists when they join.
    private _EHId = [QGVAR(fixVector), [_segment, _vector]] call CBA_fnc_globalEventJIP;
    [_EHId, _segment] call CBA_fnc_removeGlobalEventJIP;

    [_segment, _helper];
};

_fnc_spawnWireBox = {
    (_this select 2) params ["_object", "_heightASL"];
    if ((_object getVariable [QGVAR(wireBox), objNull] isNotEqualTo objNull)) exitWith {};
    private _bbr = (3 boundingBoxReal _object);
    private _relPos = _object modelToWorldWorld [((_bbr select 0 select 0) + (_bbr select 1 select 0))/2, _bbr select 0 select 1, _bbr select 0 select 2];
    _relPos set [2, _heightASL];

    private _wireBox = createVehicle ["rid_wireBox_master", (ASLToAGL _relPos), [], 0, "CAN_COLLIDE"];
    [_wireBox, _object] call BIS_fnc_attachToRelative;

    _wireBox setVectorDir (vectorDir _object);
    _wireBox setPosASL _relPos;

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
[_object0, _fnc_spawnWireBox, [_object0, _heightASL]] call EFUNC(network,createNetworkNode);

//Designate a space in the rid_tripwire_parts array of _object0 and retrieve the index of said space:
private _existingTripwiresParts = _object0 getVariable [QGVAR(tripwires_parts),[]];
private _tripwirePartsIndex = _existingTripwiresParts pushBack [];
_object0 setVariable [QGVAR(tripwires_parts), _existingTripwiresParts, true];

[_object1, _object0] call BIS_fnc_attachToRelative;

private _tripwireParts = [];
private _tripWirePartsAmount = ceil _distanceBetweenNodes;

switch (true) do {

    //Should distance between objects be smaller than 1m, spawn a single segment at the median point:
    case(_tripWirePartsAmount == 1): {
        private _tripWirePartPos = [[_object0, _object1]] call FUNC(calculateObjectsCenter);
        _tripWirePartPos set [2, _heightASL];
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
            _tripWirePartPos set [2, _heightASL];
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
private _existingTripwiresParts = _object0 getVariable [QGVAR(tripwires_parts),[] ];
_existingTripwiresParts set [_tripwirePartsIndex, _tripwireParts];
_object0 setVariable [QGVAR(tripwires_parts), _existingTripwiresParts, true];

//Delete tripwire when oject is deleted:
_object0 addEventHandler ["Deleted", {
    params ["_entity"];
    _entity call FUNC(defuseTripWire);
}];