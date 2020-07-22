  private _node0Pos = (getPosASL _node0);
    private _x0 = (_node0Pos select 0);
    private _y0 = (_node0Pos select 1);
    
    private _node1Pos = (getPosASL _node1);
    private _x1 = (_node1Pos select 0);
    private _y1 = (_node1Pos select 1);
    
    private _cableParentPos = [(_x0 + _x1)/2, (_y0 + _y1)/2, 0.5];
    
    private _cableParent = "Helper_Base_F" createVehicle _cableParentPos;
    [_cableParent, {{ _x addCuratorEditableObjects [[_this],true ] } forEach allCurators;}] remoteExec ["call", 2];
    
    private _distanceBetweenNodes = (_node0 distance2D _node1);
    private _directionVector = _node0Pos vectorFromTo _node1Pos;
    private _direction = _node0 getDir _node1;
    
    private _cableSegments = [];
    private _cableSegmentsAmount = ceil (_distanceBetweenNodes / 2);
    
    for "_i" from 1 to _cableSegmentsAmount do {
        private _offset = _i * 2 - 1;
        private _cableSegmentPos = (_node0Pos vectorAdd ( _directionVector vectorMultiply (_offset)));
        _cableSegmentPos set [2, 0.5];
        private _surfaceNormal = surfaceNormal _cableSegmentPos;
        
        //Land_WoodenWall_03_s_pole_F
        _cableSegment = createVehicle ["Land_NetFence_03_m_pole_F",_cableSegmentPos, [], 0, "CAN_COLLIDE"];
        [_cableSegment, _cableParent, false] call BIS_fnc_attachToRelative;
        _cableSegments pushBack (_cableSegment); 
        
        _cableSegment setVectorUp _directionVector;
        //_cableSegment setVectorUp surfaceNormal position _cableSegment;
        
        //_cableSegment setVectorUp[1,1,1];
    };
    _cableParent setVariable [QGVAR(cableSegments), _cableSegments];
    _cableParent setVariable [QGVAR(networkConnections), [_node0, _node1]];
    
    _node0NetworkConnections = _node0 getVariable [QGVAR(networkConnections), []];
    _node1NetworkConnections = _node1 getVariable [QGVAR(networkConnections), []];
    
    _node0NetworkConnections pushBackUnique _cableParent;
    _node1NetworkConnections pushBackUnique _cableParent;
    
    _node0 setVariable [QGVAR(networkConnections), _node0NetworkConnections];
    _node1 setVariable [QGVAR(networkConnections), _node1NetworkConnections];
    