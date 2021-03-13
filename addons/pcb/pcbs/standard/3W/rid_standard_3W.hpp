#define WIRES 3W

class rid_standard_3W_base {
    idd = 3300;
    movingEnable = false;
    enableSimulation = true;
    name="PCB";
    onLoad = QUOTE(uiNamespace setVariable ['rid_pcb_dialog', _this select 0]);
    attributes[] = {QGVAR(lopDetection), QGVAR(hasPower), QGVAR(hasDetonator), QGVAR(hasExternal)};
    class wireDictionary {
        0[]={CR3("bat"),CR3("ext"),CR3("det")};
        1[]={CR3("ext"),CR3("bat"),CR3("det")};
        2[]={CR3("ext"),CR3("det"),CR3("bat")};
        3[]={CR3("bat"),CR3("det"),CR3("ext")};
        4[]={CR3("det"),CR3("bat"),CR3("ext")};
        5[]={CR3("det"),CR3("ext"),CR3("bat")};
    };
    class Controls {

        class A : rid_clickzone 
        {
            type = 16;
            idc = 100;
            x = 0.673;
            y =  0.01851852;
            w = 0.04916667;
            h = 0.0925926;
            style = 0;
            text = "";
        };
        class A_A : rid_clickzone 
        {
            type = 16;
            idc = 101;
            x = 0.60989584 + 0.043;
            y = 0.13888889;
            w = 0.035;
            h = 0.07407408;
            style = 0;
            text = "";
        };
        class A_B : rid_clickzone 
        {
            type = 16;
            idc = 102;
            x = 0.65416667 + 0.052;
            y = 0.13425926;
            w = 0.039;
            h = 0.08;
            style = 0;
            text = "";
        };
        class B : rid_clickzone 
        {
            type = 16;
            idc = 103;
            x =  0.7046875 + 0.065;
            y =  0.55092593;
            w = 0.065;
            h = 0.06018519;
            style = 0+2+2048;
            text = "";
        };
        class B_A : rid_clickzone 
        {
            type = 16;
            idc = 104;
            x = 0.68385417  + 0.06;
            y = 0.53240741;
            w =  0.02;
            h = 0.044;
            style = 0;
            text = "";
        };
        class B_B : rid_clickzone 
        {
            type = 16;
            idc = 105;
            x = 0.68385417  + 0.06;
            y = 0.59;
            w =  0.02;
            h = 0.034;
            style = 0;
            text = "";
        };
        class C : rid_clickzone 
        {
            type = 16;
            idc = 106;
            x = 0.18;
            y = 0.46;
            w =  0.26;
            h = 0.06018519;
            style = 0;
            text = "";
        };
        class C_A : rid_clickzone 
        {
            type = 16;
            idc = 107;
            x = 0.476;
            y =  0.47222223;
            w = 0.056;
            h = 0.031;
            style = 0;
            text = "";
        };
        class C_B : rid_clickzone 
        {
            type = 16;
            idc = 108;
            x =  0.450;
            y = 0.465;
            w = 0.022;
            h = 0.038;
            style = 0;
            text = "";            
        };
        
    };
};

#include "ext\rid_standard_3W_ext.hpp"
#include "extvib\rid_standard_3W_extvib.hpp"
#include "vib\rid_standard_3W_vib.hpp"
