;; use this demo with:
;;   ./make.py Simple
;;   ./build/GambitDemo/simple

(include "objects.scm")

(c-declare #<<header

#include <Logging/Logger.h>

void scheme_apply0(___SCMOBJ);
void scheme_apply0_x(___SCMOBJ);

___SCMOBJ fun = NULL;

void set_fun(___SCMOBJ newz) {
  fun = newz;

}

void call_fun() {
  scheme_apply0(fun);
}

header
)

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

(define (println str)
  (print str)
  (newline))

;; Event demo
(define (count-process engine)
  (let ([process-count 0])
    (obj-call (obj-get engine 'ProcessEvent) 'Attach
              (lambda (arg)
                (set! process-count (+ process-count 1))))
    (obj-call (obj-get engine 'DeinitializeEvent) 'Attach
              (lambda (arg)
                (print "process count: ")
                (println process-count)))))

(c-define (set_engine e) (IEngine*) void "set_engine" ""
  (let ([engine (**make-object-IEngine** e)])
    (count-process engine)))


 ; (include "remote-debugger/debuggee.scm")
 ; (make-rdi-host "localhost:20000")

 ; (thread-start!
 ;  (make-thread
 ;   (lambda () (##repl-debug-main))))


;(debug)