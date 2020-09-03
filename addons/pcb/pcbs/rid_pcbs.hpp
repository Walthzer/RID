#define WIRE(var1) QUOTE(PATHTOF_SYS(PREFIX,COMPONENT,pcbs\TYPE\WIRES\common\wires\var1.paa))
#define DIALOG(var1,var2,var3,var4) rid_##var1##_##var2##_##var3##_##var4##_dialog
#define CR3(var1) var1##,##var1##,##var1##

class rid_pcbs {
    class standard {
        class 3W {
            class vib{
                size[] = {0,1,2};
                class 0 {
                    dialog = "rid_standard_3W_vib_0_dialog";
                    size[] = {0,1,2,3,4,5};
                };
                class 1: 0 {
                    dialog = "rid_standard_3W_vib_1_dialog";
                };
                class 2: 0 {
                    dialog = "rid_standard_3W_vib_2_dialog";
                };
            };
            class ext: vib{
                class 0: 0 {
                    dialog = "rid_standard_3W_ext_0_dialog";
                };
                class 1: 0 {
                    dialog = "rid_standard_3W_ext_1_dialog";
                };
                class 2: 0 {
                    dialog = "rid_standard_3W_ext_2_dialog";
                };
            };
            class extvib: vib {
                class 0: 0 {
                    dialog = "rid_standard_3W_extvib_0_dialog";
                };
                class 1: 0 {
                    dialog = "rid_standard_3W_extvib_1_dialog";
                };
                class 2: 0 {
                    dialog = "rid_standard_3W_extvib_2_dialog";
                };
            };
        };
    };
};

class rid_pcb
{
    style = 2048+48;
    x = 0;
    y = 0;
    w = 1;
    h = 1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "PuristaMedium";
    sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
    size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
};
class rid_clickzone
{
    animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)";
    animTextureDisabled = "#(argb,8,8,3)color(0.3,0.3,0.3,0)";
    animTextureOver = "#(argb,8,8,3)color(0.8,0.3,0,0)";
    animTextureFocused = "#(argb,8,8,3)color(1,0.5,0,0)";
    animTexturePressed = "#(argb,8,8,3)color(1,0,0,0)";
    animTextureDefault = "#(argb,8,8,3)color(0,1,0,0)";
    color[] = {1,1,1,0};
    color2[] = {1,1,1,0};
    colorBackground[] = {1,1,1,0};
    colorBackground2[] = {1,1,1,0};
    colorBackgroundFocused[] = {1,1,1,0};
    colorDisabled[] = {1,1,1,0};
    colorFocused[] = {1,1,1,0};
    font = "PuristaMedium";
    sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
    size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
    soundClick[] = {"",10,1.0};
    soundEnter[] = {"",10,1.0};
    soundEscape[] = {"",10,1.0};
    soundPush[] = {"",10,1.0};
    textureNoShortcut = "";
    style = 2;
    text = "";
    onButtonDown = QUOTE(_this call FUNC(controlClicked));
    class HitZone
    {
        top = 0;
        right = 0;
        bottom = 0;
        left = 0;
                
    };
    class ShortcutPos
    {
        top = 0;
        left = 0;
        w = 0;
        h = 0;
                
    };
    class TextPos
    {
        top = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) - (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)) / 2;
        right = 0.005;
        bottom = 0;
        left = 0.25 * (((safezoneW / safezoneH) min 1.2) / 40);
        
    };
    
};

#include "standard\rid_standard.hpp"

