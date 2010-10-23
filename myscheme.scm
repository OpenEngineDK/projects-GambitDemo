(c-declare "extern void* oe_exported_engine;")
(c-declare "extern void (*oe_event_attach)(void*, ___SCMOBJ);")

;;(c-define-type ENGINE "ENGINE")
;;(c-define-type ENGINE* (pointer ENGINE))

(define foo
  (c-lambda (int) int
     "___result = mycfoo(___arg1);"))

(define get-engine
  (c-lambda () (pointer void)
     "___result_voidstar = oe_exported_engine;"))

(define event-attach
  (c-lambda ((pointer void) scheme-object)
            void
    "oe_event_attach(___arg1, ___arg2);"))

(define (init)
  (print "Hello World")
  (newline)
  (print (foo 42))
  (newline)
  (print (get-engine))
  (newline)
  (event-attach 
   (get-engine) ;;(obj-get (get-engine) 'InitializeEvent)
   (lambda () 
     (print "Initialize event")))
  #|(event-attach
   (obj-get (get-engine) 'ProcessEvent)
   (lambda (arg)
     (print "Process event")))
  (event-attach
   (obj-get (get-engine) 'DeinitializeEvent)
   (lambda (arg)
     (print "Deinitialize event")))|#)



;; hook in from C++ land
(c-define (myscheme) () void "myscheme" ""
  (init))

(c-define (scheme-apply0 fun) (scheme-object) void "scheme_apply0" ""
  (fun))
