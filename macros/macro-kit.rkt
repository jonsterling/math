#lang at-exp racket
(require json)

(provide emit render-macros-to-tex render-macros-to-mathjax)

(struct macro-repr (name arity inst) #:transparent)

(define (macro-reprs->jsexpr reprs)
  (make-hash
   (for/list ([repr reprs])
     (cons
      (string->symbol (macro-repr-name repr))
      (list (macro-repr-inst repr) (macro-repr-arity repr))))))

(define (write-macro-repr-latex repr port)
  (display "\\newcommand\\" port)
  (display (macro-repr-name repr) port)
  (display "[" port)
  (display (macro-repr-arity repr) port)
  (display "]{" port)
  (display (macro-repr-inst repr) port)
  (displayln "}" port))

(define macro-set (make-parameter (mutable-set)))

(define (render-macros-to-tex filename)
  (call-with-output-file filename #:exists 'replace
    (λ (port)
      (for ([repr (in-set (macro-set))])
        (write-macro-repr-latex repr port)))))

(define (render-macros-to-mathjax filename)
  (define macros (set->list (macro-set)))
  (define n (length macros))
  (call-with-output-file filename #:exists 'replace
    (λ (port)
      (write-json (macro-reprs->jsexpr macros) port))))

(define (index a b)
  (let [(tail (member a (reverse b)))]
    (and tail (length (cdr tail)))))

(define-syntax id->string
  (lambda (stx)
    (syntax-case stx ()
      ((_ id)
       (identifier? #'id)
       (datum->syntax #'id (symbol->string (syntax->datum #'id)))))))


(define (name-arg arg args)
  (string-append
   "#"
   (number->string (+ 1 (index arg args)))))
 
(define-syntax-rule (emit (id arg ...) bdy ...)
  (begin
    (define (id arg ...) (string-append bdy ...))
    (let*
        ([name (id->string id)]
         [args (list (syntax->datum #'arg) ...)]
         [arity (length args)]       
         [inst
          (let ([arg (name-arg (syntax->datum #'arg) args)] ...)
            (string-append bdy ...))])
      (set-add! (macro-set) (macro-repr name arity inst)))))
