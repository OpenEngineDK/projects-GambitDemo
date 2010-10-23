#define ___VERSION 406000
extern "C" {
#include "gambit.h"
#include "myscheme.h"
}

#include "mycfoo.h"
#include <Core/Engine.h>

using namespace OpenEngine;
using namespace OpenEngine::Core;

int mycfoo(int i) {
    return i + 1;
}

IEngine* oe_exported_engine = NULL;

/*
void oe_event_attach(IEvent<Core::InitializeEventArg>* e, IListener<Core::InitializeEventArg>* l) {
    e->Attach(*l);
}
*/

template <class EventArg>
class SchemeWrapper : public IListener<EventArg> {
public:
    ___SCMOBJ fun;
    SchemeWrapper(___SCMOBJ fun) : fun(fun) {};
    void Handle(EventArg arg) {
        //((void (*)(EventArg)) fun)(arg);
        scheme_apply0(fun);
    }
};

void oe_event_attach(void* ptr, ___SCMOBJ fun) {
    // IEvent<Core::InitializeEventArg>* e 
    //     // = dynamic_cast<IEvent<Core::InitializeEventArg>*>(ptr);
    //     = (IEvent<Core::InitializeEventArg>*)(ptr);
    IEngine* e = (IEngine*)ptr;
    if (!e) return;
    SchemeWrapper<Core::InitializeEventArg>* w
        = new SchemeWrapper<Core::InitializeEventArg>(fun);
    e->InitializeEvent().Attach(*w);
}
