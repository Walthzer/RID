#ifdef TRIGGER
    #undef TRIGGER
#endif
#define TRIGGER vib
class rid_standard_3W_vib_base: rid_standard_3W_base {
    attributes[] = {QGVAR(lopDetection), QGVAR(hasPower), QGVAR(hasDetonator)};
    class wireDictionary {
        0[]={CR3("bat"),CR3("dec"),CR3("det")};
        1[]={CR3("dec"),CR3("bat"),CR3("det")};
        2[]={CR3("dec"),CR3("det"),CR3("bat")};
        3[]={CR3("bat"),CR3("det"),CR3("dec")};
        4[]={CR3("det"),CR3("bat"),CR3("dec")};
        5[]={CR3("det"),CR3("dec"),CR3("bat")};
    };
};
#include "0\rid_standard_3W_vib_0.hpp"
#include "1\rid_standard_3W_vib_1.hpp"
#include "2\rid_standard_3W_vib_2.hpp"
