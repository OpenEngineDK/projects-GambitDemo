;;;; object interface

;; obj-get : object field -> object
;; obj-set! : object field -> void

(c-declare "#include <Core/IEngine.h>")
(c-declare "using namespace OpenEngine::Core;")

(c-define-type IEngine "IEngine")
(c-define-type IEngine* (pointer IEngine))

(c-define-type InitializeEvent*   (pointer "IEvent<InitializeEventArg>"))
(c-define-type ProcessEvent*      (pointer "IEvent<ProcessEventArg>"))
(c-define-type DeinitializeEvent* (pointer "IEvent<DeinitializeEventArg>"))

(c-define-type InitializeEventArg   "InitializeEventArg")
(c-define-type ProcessEventArg      "ProcessEventArg")
(c-define-type DeinitializeEventArg "DeinitializeEventArg")

(c-define (**handle-InitializeEvent** fun arg) (scheme-object InitializeEventArg)
          void "handle_InitializeEvent" ""
  ((car fun) (**make-object-InitializeEventArg** arg)))

(c-define (**handle-ProcessEvent** fun arg) (scheme-object ProcessEventArg)
          void "handle_ProcessEvent" ""
  ((car fun) (**make-object-ProcessEventArg** arg)))

(c-define (**handle-DeinitializeEvent** fun arg) (scheme-object DeinitializeEventArg)
          void "handle_DeinitializeEvent" ""
  ((car fun) (**make-object-DeinitializeEventArg** arg)))

(c-declare #<<event-wrapper-end
  class InitializeEventWrap : public IListener<InitializeEventArg> {
    ___SCMOBJ obj;
    public:
    InitializeEventWrap(___SCMOBJ o) {
      obj = ___EXT(___make_pair)(o, ___NUL, ___STILL);
    }
    void Handle(InitializeEventArg arg) {
      handle_InitializeEvent(obj, arg);
    }
  };
  class ProcessEventWrap : public IListener<ProcessEventArg> {
    ___SCMOBJ obj;
    public:
    ProcessEventWrap(___SCMOBJ o) {
      obj = ___EXT(___make_pair)(o, ___NUL, ___STILL);
    }
    void Handle(ProcessEventArg arg) {
      handle_ProcessEvent(obj, arg);
    }
  };
  class DeinitializeEventWrap : public IListener<DeinitializeEventArg> {
    ___SCMOBJ obj;
    public:
    DeinitializeEventWrap(___SCMOBJ o) {
      obj = ___EXT(___make_pair)(o, ___NUL, ___STILL);
    }
    void Handle(DeinitializeEventArg arg) {
      handle_DeinitializeEvent(obj, arg);
    }
  };
event-wrapper-end
)

(define **object-IEngine**
  `([InitializeEvent
     ,(lambda (engine)
        (**make-object-InitializeEvent**
         ((c-lambda (IEngine*) InitializeEvent*
           "___result_voidstar = &(___arg1)->InitializeEvent();")
          engine)))
     #f]
    [ProcessEvent
     ,(lambda (engine)
        (**make-object-ProcessEvent**
         ((c-lambda (IEngine*) ProcessEvent*
            "___result_voidstar = &(___arg1)->ProcessEvent();")
          engine)))
     #f]
    [DeinitializeEvent
     ,(lambda (engine)
        (**make-object-DeinitializeEvent**
         ((c-lambda (IEngine*) DeinitializeEvent*
            "___result_voidstar = &(___arg1)->DeinitializeEvent();")
          engine)))
     #f]))

(define **object-InitializeEvent**
  `([Attach
     #f
     ,(lambda (e f)
        ((c-lambda (InitializeEvent* scheme-object) void
           "(___arg1)->Attach(*(new InitializeEventWrap(___arg2)));")
         e f))]
    [Notify]
    [Detach]))

(define **object-ProcessEvent**
  `([Attach
     #f
     ,(lambda (e f)
        ((c-lambda (ProcessEvent* scheme-object) void
           "(___arg1)->Attach(*(new ProcessEventWrap(___arg2)));")
         e f))]
    [Notify]
    [Detach]))

(define **object-DeinitializeEvent**
  `([Attach
     #f
     ,(lambda (e f)
        ((c-lambda (DeinitializeEvent* scheme-object) void
           "(___arg1)->Attach(*(new DeinitializeEventWrap(___arg2)));")
         e f))]
    [Notify]
    [Detach]))

(define **object-ProcessEventArg**
  `([Approx
     ,(c-lambda ("ProcessEventArg") unsigned-long
        "___result = ___arg1.approx;")
     #f]))

(define **object-InitializeEventArg**
  '())

(define **object-DeinitializeEventArg**
  '())

(define (**make-object-IEngine** ptr) (cons ptr **object-IEngine**))
(define (**make-object-InitializeEvent** ptr) (cons ptr **object-InitializeEvent**))
(define (**make-object-ProcessEvent** ptr) (cons ptr **object-ProcessEvent**))
(define (**make-object-DeinitializeEvent** ptr) (cons ptr **object-DeinitializeEvent**))

(define (**make-object-ProcessEventArg** ptr) (cons ptr **object-ProcessEventArg**))
(define (**make-object-InitializeEventArg** ptr) (cons ptr **object-InitializeEventArg**))
(define (**make-object-DeinitializeEventArg** ptr) (cons ptr **object-DeinitializeEventArg**))

;; (define (**tag-object** tag ptr)
;;   (cond [(assoc tag **objects**)
;;          => (lambda (p) (cons ptr (cdr p)))]
;;         [else (error "invalid object tag %s" tag)]))

(define (obj-get obj field)
  (let ([ptr    (car obj)]
        [fields (cdr obj)])
    (cond [(assoc field fields)
           => (lambda (p) 
                (let ([getter (cadr p)])
                  (if getter
                      (getter ptr)
                      (error "attempt to get ungettable field %s" field))))]
          [else (error "invalid field %s" field)])))

(define (obj-set! obj field)
  (let ([ptr    (car obj)]
        [fields (cdr obj)])
    (cond [(assoc field fields)
           => (lambda (p) 
                (let ([setter (caddr p)])
                  (if setter
                      (setter ptr)
                      (error "attempt to set unsettable field %s" field))))]
          [else (error "invalid field %s" field)])))

(define (obj-call obj field . args)
  (let ([ptr    (car obj)]
        [fields (cdr obj)])
    (cond [(assoc field fields)
           => (lambda (p) 
                (let ([method (caddr p)])
                  (if method
                      (apply method (cons ptr args))
                      (error "attempt to call non-method %s" field))))]
          [else (error "invalid method %s" field)])))


(define (event-attach event fun)
  (obj-call event 'Attach fun))
