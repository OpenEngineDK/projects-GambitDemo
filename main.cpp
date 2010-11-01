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

#include <Scene/TransformationNode.h>
#include "GambitUI.h"
#include <Utils/Reflector.h>

// Scheme boilerplate
#define ___VERSION 406000
#include "gambit.h"
extern void* oe_exported_engine;
void run_simple ___P((),());
void set_engine ___P((OpenEngine::Core::IEngine* engine),());
void do_eval ___P((char * str),());

#define GAMBIT_LIBRARY_LINKER ____20_simple__
___BEGIN_C_LINKAGE
extern ___mod_or_lnk GAMBIT_LIBRARY_LINKER (___global_state_struct*);
___END_C_LINKAGE


// name spaces that we will be using.
// this combined with the above imports is almost the same as
// fx. import OpenEngine.Logging.*; in Java.
using namespace OpenEngine;
using namespace OpenEngine::Core;
using namespace OpenEngine::Utils;
using namespace OpenEngine::Display;
using namespace OpenEngine::Scene;

#define REFLECT(x) extern void x();
#include <Reflect/MetaClasses.h>


int main(int argc, char** argv) {
    // Create simple setup
    QtEnvironment *env = new QtEnvironment(false);
    SimpleSetup* setup =
        new SimpleSetup("Example Project Title", 
                        env
                        );


    GambitUI *ui = new GambitUI(*env, *setup);

  
    
    int debug_settings = ___DEBUG_SETTINGS_INITIAL;
    
    // -:d- (force repl io to be stdin/stdout since terminal isn't
    // -attached)
    debug_settings =
        (debug_settings
         & ~___DEBUG_SETTINGS_REPL_MASK)
        | (___DEBUG_SETTINGS_REPL_STDIO
           << ___DEBUG_SETTINGS_REPL_SHIFT);
    // -:da
    debug_settings =
        (debug_settings
         & ~___DEBUG_SETTINGS_UNCAUGHT_MASK)
        | (___DEBUG_SETTINGS_UNCAUGHT_ALL
           << ___DEBUG_SETTINGS_UNCAUGHT_SHIFT);
    // -:dr
    debug_settings =
        (debug_settings
         & ~___DEBUG_SETTINGS_ERROR_MASK)
        | (___DEBUG_SETTINGS_ERROR_REPL
           << ___DEBUG_SETTINGS_ERROR_SHIFT);
    // -:d2
    // debug_settings =
    //     (debug_settings & ~___DEBUG_SETTINGS_LEVEL_MASK)
    //     | (2 << ___DEBUG_SETTINGS_LEVEL_SHIFT);



    // Scheme setup
    ___setup_params_struct setup_params;
    ___setup_params_reset (&setup_params);
    setup_params.version = ___VERSION;
    setup_params.linker  = GAMBIT_LIBRARY_LINKER;
    setup_params.debug_settings = debug_settings;
    ___setup(&setup_params);

    // run scheme
    set_engine(&setup->GetEngine());

    do_eval("(+ 2 2)");


    // Test some reflection...
#define REFLECT(x) x();
#include <Reflect/MetaClasses.h>

    Reflector *r = Reflector::GetInstance();
    TransformationNode *t = new TransformationNode();

    logger.info << t->GetPosition() << logger.end;

    ReflectedObj *o = r->Reflect(t);

    o->Call("Move",1.0, 2.0, 3.0);

    //o->Call("GetPosition");

    logger.info << t->GetPosition() << logger.end;

    

    // Start the engine.
    //setup->GetEngine().Start();

    // Scheme cleanup
    ___cleanup();


    // Return when the engine stops.
    return EXIT_SUCCESS;
}

