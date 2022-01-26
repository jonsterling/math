#lang at-exp racket

(require "macro-kit.rkt")

(define-global (Sub x)
  "_{" x "}")
(define-global (Sup x)
  "^{" x "}")

(define-global (BoldSymbol x)
  (match (target)
    ['katex @tex{\pmb{@x}}]
    [_ @tex{\boldsymbol{@x}}]))

(define-local (ShSymbol)
  (BoldSymbol @tex{\mathcal{S}}))

(define-local (GlSymbol)
  (BoldSymbol @tex{\mathcal{G}}))

(define-local (FamSymbol)
  (BoldSymbol @tex{\mathcal{F}}))

(define-global (Con x)
  @tex{\mathsf{@x}})

(define-global (Sh X)
  (ShSymbol)
  (Sub X))

(define-global (GL X)
  (GlSymbol)
  (Sub X))

(define-global (Gl x)
  (Con "gl")
  (Sub x))

(define-local (overline x)
  @tex{\overline{@x}})

(define-global (OpGL x)
  (overline (GlSymbol))
  (Sub x))

(define-global (OpGl x)
  (overline (Con "gl"))
  (Sub x))

(define-global (OpCat C)
  C (Sup (Con "o")))

(define-global (TotOpCat C)
  C (Sup @tex{\tilde{@(Con "o")}}))

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

(define-global (SET)
  (bold "Set"))

(define-global (FAM cat)
  (FamSymbol) (Sub cat))

(define-global (CandHom i u v)
  (bold "H") (Sub i) "(" u "," v ")")


(define-global (brc x)
  @tex{\{ @x \}})

(define-global (gl x)
  @tex{\langle @x \rangle})

(define-global (brk x)
  @tex{[@x]})

(define-global (prn x)
  @tex{(@x)})

(define-global (FullSubfib u)
  (bold "Full") (prn u))

(publish-macro-library 'topos)
