class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
        class AttributesBase
        {
            class Default;
            class Edit;                    // Default edit box (i.e., text input field)
            class Combo;                // Default combo box (i.e., drop-down menu)
            class Checkbox;                // Default checkbox (returned value is Boolean)
            class CheckboxNumber;        // Default checkbox (returned value is Number)
            class ModuleDescription;    // Module description
            class Units;                // Selection of units on which the module is applied
        };
        // Description base classes, for more information see below
        class ModuleDescription
        {
            class AnyBrain;
        };
    };
    class GVAR(IEDModule): Module_F
    {
        // Standard object definitions
        scope = 2;
        scopeCurator = 0;
        displayName = "create IED";
        icon = "a3\ui_f\data\igui\cfg\cursors\explosive_ca";
        category = "RID";

        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 1;
        isDisposable = 1;
        is3DEN = 1;

        curatorInfoType = "RscDisplayAttributeModuleNuke"; //RscDisplay for Zeus

        class Attributes
        {
            class GVAR(IEDCreation)
            {
                //--- Mandatory properties
                displayName = "IED Class: "; // Name assigned to UI control class Title
                tooltip = "Class from CfgAmmo to use for the IED."; // Tooltip assigned to UI control class Title
                property = QGVAR(IEDClass); // Unique config property name saved in SQM
                control = QGVAR(IEDClass); // UI control base class displayed in Edit Attributes window, points to Cfg3DEN >> Attributes

                expression = QUOTE(true);
                defaultValue = "";

                //--- Optional properties
                unique = 0; // When 1, only one entity of the type can have the value in the mission (used for example for variable names or player control)
                validate = "none"; // Validate the value before saving. If the value is not of given type e.g. "number", the default value will be set. Can be "none", "expression", "condition", "number" or "variable"
                typeName = "ARRAY"; // Defines data type of saved value, can be STRING, NUMBER or BOOL. Used only when control is "Combo", "Edit" or their variants
            };
            class ModuleDescription {}; // Module description should be shown last
        };

    };
};