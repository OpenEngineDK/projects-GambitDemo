// main
// -------------------------------------------------------------------
// Copyright (C) 2007 OpenEngine.dk (See AUTHORS) 
// 
// This program is free software; It is covered by the GNU General 
// Public License version 2 or any later version. 
// See the GNU General Public License for more details (see LICENSE). 
//--------------------------------------------------------------------

// OpenEngine stuff
#include <Meta/Config.h>
#include <Core/Engine.h>

// SimpleSetup
#include <Utils/SimpleSetup.h>

#include <Display/QtEnvironment.h>

extern void* oe_exported_engine;

// Scheme boilerplate
#define ___VERSION 406000
extern "C" {
#include "gambit.h"
#include "myscheme.h"
}
#define GAMBIT_LIBRARY_LINKER ____20_myscheme__
___BEGIN_C_LINKAGE
extern ___mod_or_lnk GAMBIT_LIBRARY_LINKER (___global_state_struct*);
___END_C_LINKAGE


// name spaces that we will be using.
// this combined with the above imports is almost the same as
// fx. import OpenEngine.Logging.*; in Java.
using namespace OpenEngine;
using namespace OpenEngine::Core;
using namespace OpenEngine::Utils;
//using namespace OpenEngine::Display;



int main(int argc, char** argv) {
    // Create simple setup
    SimpleSetup* setup =
        new SimpleSetup("Example Project Title"
                        //, new QtEnvironment()
                        );

    oe_exported_engine = &setup->GetEngine();
    // 
    


    // Scheme setup
    ___setup_params_struct setup_params;
    ___setup_params_reset (&setup_params);
    setup_params.version = ___VERSION;
    setup_params.linker  = GAMBIT_LIBRARY_LINKER;
    ___setup(&setup_params);

    // run scheme
    myscheme();

    // Scheme cleanup
    ___cleanup();

    // Start the engine.
    // setup->GetEngine().Start();

    // Return when the engine stops.
    return EXIT_SUCCESS;
}
