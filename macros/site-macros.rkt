#lang at-exp racket

(require "macro-kit.rkt")

(define-global (Sub x)
  "_{" x "}")
(define-global (Sup x)
  "^{" x "}")

(define-local ShSymbol
  @tex{\boldsymbol{\mathcal{S}}})

(define-local GlSymbol
  @tex{\boldsymbol{\mathcal{G}}})

(define-local FamSymbol
  @tex{\boldsymbol{\mathcal{F}}})

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

(define-global (OpCat C)
  C (Sup (Con "o")))

(define-global (Cod C)
  (Con "cod")
  (Sub C))

(define-local (bold kwd)
  @tex{\mathbf{@kwd}})

(define-global (TOP E)
  (bold "Top")
  (Sub E))

(define-global (Idn x)
  "1" (Sub x))

(define-global (TotCat E)
  @tex{\widetilde{@E}})

(define-global (SelfIx B)
  @tex{\underline{@B}})

(define-global (Sl E e)
  E (Sub @tex{/@e}))

(define-global (InvImg f)
  f (Sup @tex{*}))

(define-global SET
  (bold "Set"))

(define-global (FAM cat)
  FamSymbol (Sub cat))

(define-global (CandHom i u v)
 (bold "H") (Sub i) "(" u "," v ")")


(define-global (brc x)
  @tex{\{ @x \}})

(publish-macro-library 'site-macros)
