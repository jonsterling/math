#lang at-exp racket

(require "macro-kit.rkt")

@define[(Sub x)]{
 @(string-append "_{" x "}")
}

@define[ShSymbol]{
 \boldsymbol{\mathcal{S}}
}

@define[GlSymbol]{
 \boldsymbol{\mathcal{G}}
}

@emit[(Con x)]{
 \mathsf{@x}
}

@emit[(Sh X)]{
 @ShSymbol @Sub[@X]
}

@emit[(GL X)]{
 @GlSymbol @Sub[@X]
}

@emit[(Gl x)]{
 @Con{gl}@Sub[@x]
}

@emit[(OpGL X)]{
 \overline{@GlSymbol}@Sub[@X]
}

@emit[(OpGl x)]{
 \overline{\mathsf{gl}}@Sub[@x]
}

@emit[(Cod C)]{
 @Con{cod}@Sub[C]
}

@emit[(TOP E)]{
 \mathbf{Top}@Sub{E}
}

(render-macros-to-tex "../assets/macros/topos.sty")
(render-macros-to-mathjax "../assets/macros/topos.json")
