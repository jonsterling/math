
#lang at-exp racket

(require "macro-kit.rkt")

(provide Sub Sup Con overline bold brc)

(define-local (overline x)
  @tex{\overline{@x}})

(define-local (bold kwd)
  @tex{\mathbf{@kwd}})


(define-global (Sub x)
  "_{" x "}")

(define-global (Sup x)
  "^{" x "}")

(define-global (Con x)
  @tex{\mathsf{@x}})

(define-global (brc x)
  @tex{\{ @x \}})
