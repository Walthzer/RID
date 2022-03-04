#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Create a ghost tripwire in the Eden editor.
 *
 * Arguments:
 * 0: Combo <CONTROL>
 * 1: List of items <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_comboCtrl, cachedIEDItems] call rid_eden_fnc_tripwireModuleCreateWire;
 *
 * Public: [No]
 */
params["_module", "_tripwireNodes", ["_replaceOldWire", false]];
TRACE_3("tripwireModuleCreateWire",_module,_tripwireNodes,_replaceOldWire);
_tripwireNodes params ["_node0", "_node1"];


//Limit wire updates to once per frame:
private _lastUpdateFrame = _module getVariable [QGVAR(lastUpdateFrame), 0];
if (_lastUpdateFrame == diag_frameNo) exitWith {};

if (_replaceOldWire) then {
    [_module] call FUNC(tripwireModuleRemoveWire);
};


_height = (getPosASL _module) select 2;
private _distanceBetweenNodes = (_node0 distance2D _node1);
private _node0Pos = getPosASL _node0;
private _directionVector =  _node0Pos vectorFromTo (getPosASL _node1);

private _tripwireParts = [];
private _tripWirePartsAmount = ceil _distanceBetweenNodes;

//Create a tripwirePart: an 1m segment of tripwire
private _fnc_createPart = {
    params["_position", "_vector"];

    private _segment = createVehicle ["rid_tripWire_segment_ammo", (ASLToAGL _position), [], 0, "CAN_COLLIDE"];
    _segment setVectorDir _vector;

    _segment
};

_fnc_spawnWireBox = {
    params ["_object", "_height"];
    private _bbr = (3 boundingBoxReal _object);
    private _relPos = _object modelToWorldWorld [((_bbr select 0 select 0) + (_bbr select 1 select 0))/2, _bbr select 0 select 1, _bbr select 0 select 2];
    _relPos set [2, _height];

    private _wireBox = createSimpleObject ["rid_wireBox_master", _relPos];

    _wireBox setVectorDir (vectorDir _object);

    _wireBox
};

switch (true) do {

    //Should distance between objects be smaller than 1m, spawn a single segment at the median point:
    case(_tripWirePartsAmount == 1): {
        private _tripWirePartPos = [_tripwireNodes] call FUNC(calculateObjectsCenter);
        _tripWirePartPos set [2, _height];
        private _tripWirePart = [_tripWirePartPos, _directionVector] call _fnc_createPart;
        private _wireBox = [_node0, _height] call _fnc_spawnWireBox;

        _tripwireParts append [_tripWirePart, _wireBox];
    };
    
    //When distance is above 1m, spawn parts until the last full meter:
    case(_tripWirePartsAmount > 1): {
        private _tripWirePartPos = [];
        for "_i" from 1 to (_tripWirePartsAmount - 1) do {
            private _offset = _i - 0.5;
            _tripWirePartPos = (_node0Pos vectorAdd ( _directionVector vectorMultiply _offset));
            _tripWirePartPos set [2, _height];
            private _tripWirePart = [_tripWirePartPos, _directionVector] call _fnc_createPart;

            _tripwireParts pushBack _tripWirePart;
        };
        //Fill up the space between the last segment and _object1 by clipping a segement in the last created segment, filling up the remainder.
        _tripWirePartPos = (_tripWirePartPos vectorAdd ( _directionVector vectorMultiply (1 + (_distanceBetweenNodes - _tripWirePartsAmount))));
        private _tripWirePart = [_tripWirePartPos, _directionVector] call _fnc_createPart;
        private _wireBox = [_node0, _height] call _fnc_spawnWireBox;

        _tripwireParts append [_tripWirePart, _wireBox];
        
    };
};

_module setVariable [QGVAR(tripwireParts), _tripwireParts];