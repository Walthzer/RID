class CBA_Extended_EventHandlers;

class CfgVehicles
{
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {
                class RID_DigForCable {
                    displayName = CSTRING(DigForCableAction_Displayname);
                    condition = QUOTE([_player] call ACE_FUNC(common,canDig) && {ARG_2(true,[_player] call ACE_FUNC(common,isEngineer),GVAR(requireEngineer))});
                    exceptions[] = {};
                    statement = QUOTE(call FUNC(digForWire));
                    showDisabled = 0;
                };
            };
        };
    };

    class Helper_Base_F;
    class rid_tripWire_helper: Helper_Base_F {};
    class rid_wireLink: Helper_Base_F {};

    class rid_virtualIED: Helper_Base_F {
        scope = 1;
        scopeCurator = 1;
        author = "Walthzer/Shark";
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };
    };

    class static;
    class rid_dirt: static {
        author = "Walthzer/Shark";
        mapSize = 1;
        scope = 1;
        cost = 1;
        scopeCurator = 2;
        editorPreview = "";
        icon = "iconObject_2x1";
        model = QPATHTOF(models\rid_dirt);
        hiddenSelections[] = {"camo"};
/*         class SimpleObject {
            animate[] = {};
            eden = 0;
            hide[] = {};
            init = "''";
            verticalOffset = 1.284;
            verticalOffsetWorld = 0;
        }; */
    };

    class rid_wireHelper: static {
        author = "Walthzer/Shark";
        mapSize = 1;
        isCW=1;
        ace_minedetector_detectable=1;
        scope = 1;
        scopeCurator = 1;
        armor = 100;
        cost = 0;
        model = QPATHTOF(models\rid_wireHelper);
        destrType="DestructDefault";
        simulation="house";
        driveThroughEnabled = 1;
        //class EventHandlers {
            //hitpart = QUOTE(_this call EFUNC(network,wireSegmentDammaged));
        //};
    };

    class rid_commandWireCut: rid_wireHelper {
        model = QPATHTOF(models\rid_commandWireCut);
        destrType="DestructNo";
    };

    class rid_commandWireComplete: rid_wireHelper {
        class ACE_Actions {
            class RID_defuseWire {
                displayName = CSTRING(CutAction_Displayname);
                condition = "alive _target";
                statement = QUOTE(_target call FUNC(commandWireCut));
                distance = 1;
                selection = "poles";
            };
        };
        armor = 0.5;
        model = QPATHTOF(models\rid_commandWireComplete);
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };
    };

    class Items_base_F;
    class rid_wireDetonator: Items_base_F
    {
        class ACE_Actions {
            class RID_activateWireDetonator {
                displayName = CSTRING(ActivateWireDetonatorAction_Displayname);
                condition = "alive _target";
                statement = QUOTE([_target] spawn FUNC(boxTrigger));
                icon = "";
                exceptions[] = {};
                insertChildren = "";
                modifierFunction = "";
                runOnHover = 0;
                distance = 0.5;
            };
            class RID_defuseWireDetonator: RID_activateWireDetonator {
                displayName = CSTRING(DefuseWireDetonatorAction_Displayname);
                condition = "_target getVariable['rid_core_isConnected', false]";
                statement = "_target setVariable['rid_core_isConnected', false, true]";
                selection = "poles";
            };
        };

        author = "Walthzer/Shark";
        isCW=1;
        ace_minedetector_detectable=1;
        mapSize = 0.2;
        editorPreview = QPATHTOF(data\rid_wireDetonator_preview.jpg);
        scope = 2;
        scopeCurator = 2;
        displayName = CSTRING(WireDetonator);
        model = QPATHTOF(models\rid_wireDetonator);
        icon = "iconObject_4x1";
        editorSubcategory = "EdSubcat_Electronics";

        class EventHandlers
        {
            init = QUOTE([ARR_2(_this select 0,{_this select 0 setVariable[ARR_3('rid_core_isConnected',true,true)]})] call EFUNC(network,createNetworkNode)); //Thank you Dahlgren
        };
    };

    class rid_wireBox_base: Items_base_F
    {
        class ACE_Actions {
            class RID_defuseWireBox {
                displayName = CSTRING(DefuseWireDetonatorAction_Displayname);
                condition = "_target getVariable['rid_core_isConnected', false]";
                statement = "_target setVariable['rid_core_isConnected', false, true]";
                distance = 0.5;
                selection = "poles";
            };
        };
        author = "Walthzer/Shark";
        isCW=1;
        ace_minedetector_detectable=1;
        mapSize = 0.2;
        scope = 1;
        armor = 25;
        displayName = CSTRING(WireBox);
        icon = "iconObject_4x1";
        editorSubcategory = "EdSubcat_Electronics";
        model = QPATHTOF(models\rid_wireBox_flat);
    };

    class rid_wireBox_vibrationDetector: rid_wireBox_base
    {
        displayName = CSTRING(VibrationDetector);
        scope = 2;
        scopeCurator = 2;

        class EventHandlers
        {
            init = QUOTE([ARR_2(_this select 0,{_this select 0 setVariable[ARR_3('rid_core_isConnected',true,true)]})] call EFUNC(network,createNetworkNode);[_this select 0] call FUNC(createVibrationDetector));
        };
    };

    class rid_wireBox_master: rid_wireBox_base
    {
        class ACE_Actions {
            class RID_defuseTrigger {
                condition = "(_target getVariable['rid_core_master', objNull]) getVariable['rid_core_isConnected', false]";
                statement = "(_target getVariable['rid_core_master', objNull]) setVariable['rid_core_isConnected', false, true]";
            };
        };

        model = QPATHTOF(models\rid_wireBox);
    };

    class MineBase;
    class rid_tripWire_base: MineBase
    {
        author = "Walthzer/Shark";
        isCW=1;
        mapSize=3.0599999;
        scope=2;
        ammo="rid_tripWire_base_Ammo";
        displayName = "RID Network Tripwire APERS variant"; 
        icon="iconExplosiveAP";
        picture="\A3\Weapons_F\Data\clear_empty.paa";
        model="\A3\Weapons_F\explosives\mine_AP_tripwire";
        hiddenSelections[]={"camo", "start", "end"};

    };
    class rid_tripWire_segment: rid_tripWire_base
    {
        displayName = "RID Network Tripwire";
        editorPreview = QPATHTOF(data\rid_tripWire_segment_preview.jpg);
        ammo = "rid_tripWire_segment_Ammo";
        model = QPATHTOF(models\rid_tripwire);
        mapSize=1;
    };
};