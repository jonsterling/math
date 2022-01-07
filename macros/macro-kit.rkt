#lang at-exp racket

(require json)

(provide tex define-global define-local publish-macro-library)

(struct macro-repr (name arity inst) #:transparent)

(define (macro-reprs->mathjax-jsexpr reprs)
  (make-hash
   (for/list ([repr reprs])
     (cons
      (string->symbol (macro-repr-name repr))
      (list (macro-repr-inst repr) (macro-repr-arity repr))))))

(define (macro-reprs->katex-jsexpr reprs)
  (make-hash
   (for/list ([repr reprs])
     (cons
      (string->symbol (macro-repr-name repr))
      (macro-repr-inst repr)))))

(define (write-macro-repr-latex repr port)
  (display "\\newcommand\\" port)
  (display (macro-repr-name repr) port)
  (when (> (macro-repr-arity repr) 0)
    (display "[" port)
    (display (macro-repr-arity repr) port)
    (display "]" port))
  (display "{" port)
  (display (macro-repr-inst repr) port)
  (displayln "}" port))

(define macro-set (make-parameter (mutable-set)))

(define (macro-list)
  (define (lt? repr1 repr2)
    (string<? (macro-repr-name repr1) (macro-repr-name repr2)))
  
  (sort (set->list (macro-set)) lt?))

(define (render-macros-to-tex filename)
  (call-with-output-file filename #:exists 'replace
    (λ (port)
      (for ([repr (in-list (macro-list))])
        (write-macro-repr-latex repr port)))))

(define (render-macros-to-mathjax filename)
  (define macros (macro-list))
  (call-with-output-file filename #:exists 'replace
    (λ (port)
      (write-json (macro-reprs->mathjax-jsexpr macros) port))))

(define (render-macros-to-katex filename)
  (define macros (macro-list))
  (call-with-output-file filename #:exists 'replace
    (λ (port)
      (write-json (macro-reprs->katex-jsexpr macros) port))))

(define (publish-macro-library sym)
  (define (filename ext)
    (string-append "../assets/macros/" (symbol->string sym) "." ext))
  (render-macros-to-tex (filename "sty"))
  (render-macros-to-mathjax (filename "mathjax.json"))
  (render-macros-to-katex (filename "katex.json")))

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

(define (tex . args)
  (string-append* args))

(define-syntax-rule (define-local head bdy ...)
  (begin
    (define head (tex bdy ...))))
 
(define-syntax define-global
  (syntax-rules ()
    [(emit (id arg ...) bdy ...)
     (begin
       (define (id arg ...) (string-append "" bdy ...))
       (let*
           ([name (id->string id)]
            [args (list (syntax->datum #'arg) ...)]
            [arity (length args)]       
            [inst
             (let ([arg (name-arg (syntax->datum #'arg) args)] ...)
               (tex bdy ...))])
         (set-add! (macro-set) (macro-repr name arity inst))))]
    [(emit id bdy ...)
     (begin
       (define id (tex bdy ...))
       (let ([name (id->string id)])
         (set-add! (macro-set) (macro-repr name 0 id))))]))
