class CfgVehicles
{
    class Helper_Base_F;
    class rid_tripWire_helper: Helper_Base_F {};
    
    class rid_wireLink: Helper_Base_F {};

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
                statement = QUOTE(_target setVariable['rid_core_isConnected', false]);
                selection = "poles";
            };
        };

        author = "Walthzer/Shark";
        isCW=1;
        mapSize = 0.2;
        editorPreview = QPATHTOF(data\rid_wireDetonator_preview.jpg);
        _generalMacro = "";
        scope = 2;
        scopeCurator = 2;
        displayName = "Wire Detonator";
        model = QPATHTOF(rid_wireDetonator);
        icon = "iconObject_4x1";
        editorSubcategory = "EdSubcat_Electronics";

        class EventHandlers
        {
            init = QUOTE([_this select 0, {(_this select 0) setVariable['rid_core_isConnected', true]}] call EFUNC(network,createNetworkNode));
        };
    };

    class MineBase;
    class rid_tripWire_base: MineBase
    {
        author = "Walthzer/Shark";
        isCW=1;
        mapSize=3.0599999;
        editorPreview="";
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