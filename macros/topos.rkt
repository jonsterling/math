#lang at-exp racket

(require "macro-kit.rkt")

(define-local (Sub x)
  "_{" x "}")

(define-local ShSymbol
  @tex{\boldsymbol{\mathcal{S}}})

(define-local GlSymbol
  @tex{\boldsymbol{\mathcal{G}}})

(define-global (Con x)
  @tex{\mathsf{@x}})

(define-global (Sh X)
  ShSymbol
  (Sub X))

(define-global (GL X)
  GlSymbol
  (Sub X))

(define-global (Gl x)
  (Con "gl")
  (Sub x))

(define-local (overline x)
  @tex{\overline{@x}})

(define-global (OpGL x)
  (overline GlSymbol)
  (Sub x))

(define-global (OpGl x)
  (overline (Con "gl"))
  (Sub x))

(define-global (Cod C)
  (Con C)
  (Sub C))

(define-local (bold kwd)
  @tex{\mathbf{@kwd}})

(define-global (TOP E)
  (bold "Top")
  (Sub E))

(publish-macro-library 'topos)
