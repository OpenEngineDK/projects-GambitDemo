;; use this demo with:
;;   ./make.py Simple
;;   ./build/GambitDemo/simple

(c-declare #<<header
void scheme_apply0(___SCMOBJ);

___SCMOBJ fun = NULL;

void set_fun(___SCMOBJ new) {
  fun = new;
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

(define (make-list n e)
  (if (zero? n)
      '()
      (cons e (make-list (- n 1) e))))

(define (make-garbage n)
  (if (zero? n)
      '()
      (cons (make-list 100 (lambda () (print n) (newline)))
            (make-garbage (- n 1)))))

(begin
  (let ((x 7) (y 42))
    (set-fun (caar (make-garbage 100)))
    (##gc)
    (call-fun)
    (set-fun (caar (make-garbage 100)))
    (##gc)
    (call-fun)))
