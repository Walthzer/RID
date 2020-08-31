class CBA_Extended_EventHandlers;

class CfgVehicles
{
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {
                class ACE_DigForCable {
                    displayName = "Dig for cable";
                    condition = QUOTE([_player] call ace_common_fnc_isEngineer && {[_player] call ace_common_fnc_canDig});
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

    class static;
    class rid_dirt: static {
        author = "Walthzer/Shark";
        mapSize = 1;
        scope = 1;
        cost = 1;
        scopeCurator = 2;
        editorPreview = "";
        icon = "iconObject_2x1";
        model = QPATHTOF(rid_dirt);
        class SimpleObject {
            animate[] = {};
            eden = 0;
            hide[] = {};
            init = "''";
            verticalOffset = 1.284;
            verticalOffsetWorld = 0;
        };
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
        model = QPATHTOF(rid_wireHelper);
        destrType="DestructDefault";
        simulation="house";
        driveThroughEnabled = 1;
        //class EventHandlers {
            //hitpart = QUOTE(_this call EFUNC(network,wireSegmentDammaged));
        //};
    };

    class rid_commandWireCut: rid_wireHelper {
        model = QPATHTOF(rid_commandWireCut);
        destrType="DestructNo";
    };

    class rid_commandWireComplete: rid_wireHelper {
        class ACE_Actions {
            class defuseWire {
                displayName = "Cut";
                condition = QUOTE(alive _target);
                statement = QUOTE(_target call FUNC(commandWireCut));
                distance = 1;
                selection = "poles";
            };
        };
        armor = 0.5;
        model = QPATHTOF(rid_commandWireComplete);
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers {};
        };
    };

    class Items_base_F;
    class rid_wireDetonator: Items_base_F
    {
        class ACE_Actions {
            class activateTrigger {
                displayName = "Press the buttons";
                condition = "alive _target";
                statement = QUOTE([_target] spawn FUNC(boxTrigger));
                icon = "";
                exceptions = [];
                insertChildren = "";
                modifierFunction = "";
                runOnHover = 0;
                distance = 0.5;
            };
            class defuseTrigger: activateTrigger {
                displayName = "Detach wires";
                condition = QUOTE(_target getVariable['rid_core_isConnected', false]);
                statement = QUOTE(_target setVariable['rid_core_isConnected', false, true]);
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
        displayName = "Wire Detonator";
        model = QPATHTOF(rid_wireDetonator);
        icon = "iconObject_4x1";
        editorSubcategory = "EdSubcat_Electronics";

        class EventHandlers
        {
            init = QUOTE([_this select 0, {(_this select 0) setVariable['rid_core_isConnected', true, true]}] call EFUNC(network,createNetworkNode));
        };
    };

    class rid_wireBox: Items_base_F
    {
        class ACE_Actions {
            class defuseTrigger {
                displayName = "Detach wires";
                condition = QUOTE((_target getVariable['rid_core_master', objNull]) getVariable['rid_core_isConnected', false]);
                statement = QUOTE((_target getVariable['rid_core_master', objNull]) setVariable['rid_core_isConnected', false, true]);
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
        displayName = "Wire Box";
        model = QPATHTOF(rid_wireBox);
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
        model = QPATHTOF(rid_tripwire);
        mapSize=1;
    };
};