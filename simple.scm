
;; use this demo with:
;;   ./make.py Simple
;;   ./build/GambitDemo/simple


(c-declare #<<header

#include <Logging/Logger.h>
#include <Core/IEngine.h>

using namespace OpenEngine::Core;
void scheme_apply0(___SCMOBJ);
void scheme_apply0_x(___SCMOBJ);

___SCMOBJ fun = NULL;

void set_fun(___SCMOBJ newz) {
  fun = newz;

}

void call_fun() {
  scheme_apply0(fun);
}

template <class EventArg>
class Wrap : public IListener<EventArg> {
___SCMOBJ obj;
public:
Wrap(___SCMOBJ o)  {
obj = ___EXT(___make_pair)(o, ___NUL, ___STILL);
//logger.info << ___BODY(o) << logger.end;
}

void Handle(EventArg arg) {
//logger.info << ___BODY(obj) << logger.end;
scheme_apply0_x(obj);
}
};

header
)

(c-define-type IEngine "IEngine")
(c-define-type IEngine* (pointer IEngine))



(define (set-fun fun)
  ((c-lambda (scheme-object) void
     "set_fun(___arg1);")
   (##still-copy fun)))

(define call-fun
  (c-lambda () void
    "call_fun();"))

(c-define (scheme-apply0 fun) (scheme-object) void "scheme_apply0" ""
  (fun))

(c-define (scheme-apply0-x fun) (scheme-object) void "scheme_apply0_x" ""
  ( (car fun)))


(define (make-list n e)
  (if (zero? n)
      '()
      (cons e (make-list (- n 1) e))))

(define (make-garbage n)
  (if (zero? n)
      '()
      (cons (make-list 100 (lambda () (print n) (newline)))
            (make-garbage (- n 1)))))

(c-define (run_simple) () void "run_simple" ""
  (begin
    (let ((x 7) (y 42))
      (set-fun (caar (make-garbage 100)))
      (##gc)
      (call-fun)
      (set-fun (caar (make-garbage 100)))
      (##gc)
      (call-fun))))

(define (test-att eng fun)
  ((c-lambda (IEngine* scheme-object) void
#<<ATT
Wrap<ProcessEventArg> *w = new Wrap<ProcessEventArg>(___arg2);
IEngine* eng = ___arg1;
eng->ProcessEvent().Attach(*w);
ATT
) eng fun 
))


(c-define (set_engine e) (IEngine*) void "set_engine" ""
          (print "wooo")
          (newline)
          (test-att e
                    ;(##still-obj-refcount-inc!  
                    ;(##still-copy                    
                        (lambda ()
                          (make-garbage 100)
                          ;(print "was?")
                          ;(newline)
                          ))
                                               
                     ; ))
          )


 ; (include "remote-debugger/debuggee.scm")
 ; (make-rdi-host "localhost:20000")

 ; (thread-start!
 ;  (make-thread
 ;   (lambda () (##repl-debug-main))))


;(debug)