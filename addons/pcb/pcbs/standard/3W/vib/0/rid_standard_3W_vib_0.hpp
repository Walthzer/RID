//Exported via Arma Dialog Creator (https://github.com/kayler-renslow/arma-dialog-creator)
#ifdef SERIES
    #undef SERIES
#endif
#define SERIES 0
class DIALOG(TYPE,WIRES,TRIGGER,SERIES): rid_standard_3W_vib_base {
    prefix = QPATHTOF(pcbs\TYPE\WIRES\TRIGGER\SERIES\);
    class wireDictionary {
        0[]={CR3("bat"),CR3("dec"),CR3("det")};
        1[]={CR3("det"),CR3("dec"),CR3("bat")};
        2[]={CR3("dec"),CR3("bat"),CR3("det")};
        3[]={CR3("det"),CR3("bat"),CR3("dec")};
        4[]={CR3("bat"),CR3("det"),CR3("dec")};
        5[]={CR3("dec"),CR3("det"),CR3("bat")};
    };
    class ControlsBackground
    {
        class board : rid_pcb 
        {
            type = 0;
            idc = -1;
            text = QPATHTOF(pcbs\TYPE\WIRES\TRIGGER\SERIES\common\board.paa);
            
        };
        class traces : rid_pcb 
        {
            type = 0;
            idc = 1894;
            text = "";
            
        };
        class C : rid_pcb 
        {
            type = 0;
            idc = 6;
            text = WIRE(C);
            
        };
        class parts : rid_pcb 
        {
            type = 0;
            idc = -1;
            text = QPATHTOF(pcbs\TYPE\WIRES\TRIGGER\SERIES\common\parts.paa);
            
        };
        class C_A : rid_pcb 
        {
            type = 0;
            idc = 7;
            text = WIRE(C_A);
            
        };
        class A_B : rid_pcb 
        {
            type = 0;
            idc = 2;
            text = WIRE(A_B);
            
        };
        class C_B : rid_pcb 
        {
            type = 0;
            idc = 8;
            text = WIRE(C_B);
            
        };
        class A_A : rid_pcb 
        {
            type = 0;
            idc = 1;
            text = WIRE(A_A);
            
        };
        class A : rid_pcb 
        {
            type = 0;
            idc = 0;
            text = WIRE(A);
            
        };
        class B_B : rid_pcb 
        {
            type = 0;
            idc = 5;
            text = WIRE(B_B);
            
        };
        class B : rid_pcb 
        {
            type = 0;
            idc = 3;
            text = WIRE(B);
            
        };
        class B_A : rid_pcb 
        {
            type = 0;
            idc = 4;
            text = WIRE(B_A);
            
        };
        
    };
};
