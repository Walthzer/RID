#include "\a3\3den\ui\macros.inc"

class ctrlCheckbox;
class ctrlCombo;
class ctrlEdit;
class ctrlEditMulti;
class Background;

class Cfg3DEN
{
    class Attributes // Attribute UI controls are placed in this pre-defined class
    {
        class Default;
        class Title: Default
        {
            class Controls
            {
                class Title;
            };
        };

        class GVAR(empty): Default {
            h = 0;
        };

        class GVAR(networkReceiver): Title
        {

            attributeSave = QUOTE([ARR_2(cbChecked (_this controlsGroupCtrl 100),ctrlText (_this controlsGroupCtrl 102))]);
            attributeLoad = "if (_value isEqualType '') then {_value = [false,'comment put code here;']}; (_this controlsGroupCtrl 100) cbSetChecked (_value select 0); (_this controlsGroupCtrl 102) ctrlSetText (_value select 1); [_this, _value select 0, [101,102]] call rid_eden_fnc_fadeChildCtrl; (_this controlsGroupCtrl 102) ctrlEnable (_value select 0)"; 

            h = SIZE_M * GRID_H * 5;

            class Controls: Controls
            {
                class Title: Title {};
                class Value1: ctrlCheckbox {
                    idc = 100;
                    onLoad = QUOTE([ARR_3(ctrlParentControlsGroup (_this select 0),cbChecked (_this select 0),[ARR_2(101,102)])] call FUNC(fadeChildCtrl); ((ctrlParentControlsGroup (_this select 0)) controlsGroupCtrl 102) ctrlEnable (cbChecked (_this select 0)));
                    onCheckedChanged = QUOTE([ARR_3(ctrlParentControlsGroup (_this select 0),(_this select 1),[ARR_2(101,102)])] call FUNC(fadeChildCtrl); ((ctrlParentControlsGroup (_this select 0)) controlsGroupCtrl 102) ctrlEnable ([ARR_2(false,true)] select (_this select 1)));
                    x = ATTRIBUTE_TITLE_W * GRID_W;
                    w = SIZE_M * GRID_W;
                    h = SIZE_M * GRID_H;
                };
                class Background: Title {
                    onLoad = "(_this select 0) ctrlEnable false";
                    colorBackground[] = {0,0,0,0.6};
                    style = "0x10 + 0x200";
                    x = SIZE_M * GRID_W;
                    y = (2.5 + SIZE_M) * GRID_H;
                    w = (ATTRIBUTE_CONTENT_W + ATTRIBUTE_TITLE_W - SIZE_M) * GRID_W;
                    h = 5 * SIZE_XS * GRID_H;
                };
                class Title1: Title {
                    idc = 101;
                    onLoad = "(_this select 0) ctrlEnable false";
                    text = "Network Reciever Code: ";
                    style = 64;
                    x = SIZE_M * GRID_W;
                    y = SIZE_M * GRID_H;
                    w = (ATTRIBUTE_CONTENT_W + ATTRIBUTE_TITLE_W - SIZE_M) * GRID_W;
                    h = 4 * SIZE_M * GRID_H;
                };
                class Value: ctrlEditMulti {
                    idc = 102;
                    colorBackground[] = {0,0,0,0};
                    autocomplete = "scripting";
                    style = "0x10 + 0x200";
                    font = FONT_NORMAL;
                    x = SIZE_M * GRID_W;
                    y = (4 + SIZE_M) * GRID_H;
                    w = (ATTRIBUTE_CONTENT_W + ATTRIBUTE_TITLE_W - SIZE_M) * GRID_W;
                    h = 4.5 * SIZE_XS * GRID_H;
                };
            };
        };

        class GVAR(pressurePlate): Title
        {

            attributeSave = QUOTE([ARR_2(cbChecked (_this controlsGroupCtrl 100),parseNumber (ctrlText (_this controlsGroupCtrl 102)))]);
            attributeLoad = "if (_value isEqualType '') then {_value = [false,0]}; (_this controlsGroupCtrl 100) cbSetChecked (_value select 0); (_this controlsGroupCtrl 102) ctrlSetText str (_value select 1); [_this, _value select 0, [101,102]] call rid_eden_fnc_fadeChildCtrl; (_this controlsGroupCtrl 102) ctrlEnable (_value select 0)"; 

            h = SIZE_M * GRID_H * 2;

            class Controls: Controls
            {
                class Title: Title {};
                class Value1: ctrlCheckbox {
                    idc = 100;
                    onLoad = QUOTE([ARR_3(ctrlParentControlsGroup (_this select 0),cbChecked (_this select 0),[ARR_2(101,102)])] call FUNC(fadeChildCtrl); ((ctrlParentControlsGroup (_this select 0)) controlsGroupCtrl 102) ctrlEnable (cbChecked (_this select 0)));
                    onCheckedChanged = QUOTE([ARR_3(ctrlParentControlsGroup (_this select 0),(_this select 1),[ARR_2(101,102)])] call FUNC(fadeChildCtrl); ((ctrlParentControlsGroup (_this select 0)) controlsGroupCtrl 102) ctrlEnable ([ARR_2(false,true)] select (_this select 1)));
                    x = ATTRIBUTE_TITLE_W * GRID_W;
                    w = SIZE_M * GRID_W;
                    h = SIZE_M * GRID_H;
                };
                class Title1: Title {
                    idc = 101;
                    onLoad = "(_this select 0) ctrlEnable false";
                    text = "Threshold: ";
                    x = 0;
                    y = SIZE_M * GRID_H;
                };
                class Value: ctrlEdit {
                    idc = 102;
                    autocomplete = "";
                    font = FONT_NORMAL;
                    x = ATTRIBUTE_TITLE_W * GRID_W;
                    y = SIZE_M * GRID_H;
                    w = ATTRIBUTE_CONTENT_W * GRID_W;
                    h = SIZE_M * GRID_H;
                };
            };
        };

        class GVAR(iedCreation): Title
        {

            attributeSave = QUOTE(ARR_2([lbCurSel (_this controlsGroupCtrl 101),lbCurSel (_this controlsGroupCtrl 103)]));
            attributeLoad = QUOTE(if (_value isEqualTo []) then {_value = [ARR_2(0,0)]}; [ARR_2((_this controlsGroupCtrl 101),(uiNamespace getVariable [ARR_2(QQEGVAR(core,cachedIEDItems), [])]))] call FUNC(comboAddItems); ((_this controlsGroupCtrl 101) lbSetCurSel (_value select 0)); ((_this controlsGroupCtrl 103) lbSetCurSel (_value select 1)););

            h = SIZE_M * GRID_H * 3;

            class Controls: Controls
            {
                class Title: Title {};
                class Value: ctrlCombo {
                    idc = 101;
                    //Populate Listbox if attributeLoad hasn't done so. (e.g. multiple entities edited at once)
                    onLoad = QUOTE(if !((lbSize (_this select 0)) == 0) then {[ARR_2(_this select 0,(uiNamespace getVariable [ARR_2(QQEGVAR(core,cachedIEDItems), [])]))] call FUNC(comboAddItems)});
                    font = FONT_NORMAL;
                    x = ATTRIBUTE_TITLE_W * GRID_W;
                    y = 0;
                    w = ATTRIBUTE_CONTENT_W * GRID_W;
                    h = SIZE_M * GRID_H;

                };
                class Title1: Title {
                    idc = 102;
                    text = "Internal Trigger: ";
                    x = 0;
                    y = (1 + SIZE_M) * GRID_H;
                };
                class Value1: ctrlCombo {
                    idc = 103;
                    onLoad = "";
                    x = ATTRIBUTE_TITLE_W * GRID_W;
                    y = (1 + SIZE_M) * GRID_H;
                    w = ATTRIBUTE_CONTENT_W * GRID_W;
                    h = SIZE_M * GRID_H;

                    class Items
                    {
                        class none 
                        {
                            text = "none";
                            value  = 0;
                            data = "";
                            default = 1;
                            tooltip = "No internal trigger";
                        };
                        class vibration 
                        {
                            text = "Vibration";
                            value = 1;
                            data = "vib";
                            tooltip = "Vibration Detector";
                        };
                    };
                };
            };
        };
    };

    //Base customConnectionClass
    class GVAR(customConnection)
    {
        displayName = "";
        data = QGVAR(customConnection);
        GVARMAIN(isCustom) = 1;
        GVARMAIN(OnScenarioStart) = "";
        GVARMAIN(OnConnection) = "";
        color[] = {0,0,0,1};
        cursor = "3DENConnectSync";
    };

    class Connections
    {
        class GVAR(networkConnection): GVAR(customConnection)
        {
            displayName = "RID Network Connection";
            data = QGVAR(networkConnection);
            GVARMAIN(OnScenarioStart) = QUOTE([ARR_4((_this select 0), (_this select 1), true, true)] call EFUNC(network,createNetworkLink));
            color[] = {0,1,0,1};
        };
    };

    class EventHandlers
    {
        class ADDON
        {
            //init = "diag_log 'RID EDEN INIT'";
            OnMissionSave = QUOTE(call FUNC(onMissionSave));
            OnConnectingEnd = QUOTE(call FUNC(onConnectingEnd));
            OnEntityMenu = QUOTE(call FUNC(onEntityMenu));
            OnCopy = QUOTE(call FUNC(onCopy)); //Fires on CTRL+ C and before CTRL + X deletes entities
            OnPaste = QUOTE(call FUNC(onPaste));
            OnPasteUnitOrig = QUOTE(call FUNC(onPaste));
            OnMissionLoad = QUOTE(GVAR(changedMission) = true);
            OnMissionNew = QUOTE(GVAR(changedMission) = true);
        };
    };

    class Mission
    {
        class GVAR(attributes) // Custom section class, everything inside will be opened in one window
        {
            displayName = "RID Eden Attributes";
            display = "";
            class AttributeCategories
            {
                class GVARMAIN(attributes)
                {
                    class Attributes
                    {
                        class GVAR(storedConnections)
                        {
                            property = QGVAR(storedConnections);
                        };
                    };
                };
            };
        };
    };

    class Logic
    {
        class AttributeCategories
        {

            class rid_attributes
            {
                displayName = "";
                collapsed = 1;
                class Attributes
                {
                    class GVAR(objectID)
                    {
                        displayName = "";
                        tooltip = "";
                        property = QGVAR(objectID);
                        control = QGVAR(empty);

                        expression = QUOTE(if (is3DEN || {_value < 0}) exitWith {}; [ARR_2(_this,_value)] call FUNC(registerObjectID));

                        defaultValue = "-1";

                        unique = 0;
                        validate = "none";
                        condition = "1";
                        typeName = "NUMBER";
                    };
                };
            };
        };
    };

    class Marker
    {
        class AttributeCategories
        {

            class rid_attributes
            {
                displayName = "";
                collapsed = 1;
                class Attributes
                {
                    class GVAR(objectID)
                    {
                        displayName = "";
                        tooltip = "";
                        property = QGVAR(objectID);
                        control = QGVAR(empty);

                        expression = QUOTE(if (is3DEN || {_value < 0}) exitWith {}; [ARR_2(_this,_value)] call FUNC(registerObjectID));

                        defaultValue = "-1";

                        unique = 0;
                        validate = "none";
                        condition = "1";
                        typeName = "NUMBER";
                    };
                };
            };
        };
    };

    class Object
    {
        class AttributeCategories
        {

            class rid_attributes
            {
                displayName = "RID";
                collapsed = 1;
                class Attributes
                {
                    class GVAR(objectID)
                    {
                        displayName = "";
                        tooltip = "";
                        property = QGVAR(objectID);
                        control = QGVAR(empty);

                        expression = QUOTE(if (is3DEN || {_value < 0}) exitWith {}; [ARR_2(_this,_value)] call FUNC(registerObjectID));

                        defaultValue = "-1";

                        unique = 0;
                        validate = "none";
                        condition = "1";
                        typeName = "NUMBER";
                    };
                    class GVAR(pressurePlate)
                    {
                        //--- Mandatory properties
                        displayName = "Assign Pressure Plate Detector:"; // Name assigned to UI control class Title
                        tooltip = "register object as a RID Pressure Plate with specified mass threshold."; // Tooltip assigned to UI control class Title
                        property = QGVAR(pressurePlate); // Unique config property name saved in SQM
                        control = QGVAR(pressurePlate); // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

                        expression = QUOTE(if (is3DEN || {!(_value select 0)}) exitWith {}; [ARR_2(_this,_value select 1)] call EFUNC(core,createPressurePlate));

                        defaultValue = "[false,0]";

                        condition = "(1-objectBrain)*(1-objectAgent)";
                    };
                    class GVAR(networkReceiver): GVAR(pressurePlate)
                    {
                        displayName = "Assign Network Reciever:";
                        tooltip = "register object as a RID network receiver with code to call on network trigger.";
                        property = QGVAR(networkReceiver);
                        control = QGVAR(networkReceiver);

                        expression = QUOTE(if (is3DEN || {!(_value select 0)}) exitWith {}; private _code = compile (_value select 1); [ARR_2(_this,_code)] call EFUNC(network,assignNetworkReciever));

                        defaultValue = "[false,'comment put code here;']";
                    };
                };
            };
        };
    };
};