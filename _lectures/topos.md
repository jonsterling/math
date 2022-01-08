---
layout: post
title: Geometric universes and topoi (draft)
date: 2022-01-08
macrolib: topos
usemathjax: true
antex:
  preamble: >-
    \usepackage{jon-tikz}
    \usepackage{mlmodern,amsfonts,amssymb,amsmath}
    \usepackage{topos}
---

{% include toc.html %}


## Geometric universes

A *geometric universe* $E$ is defined to be a cartesian closed category
equipped with a subobject classifier. A morphism $f : E \to F$ of geometric
universes is given by a functor $f^\*:F\to E$ preserving finite limits equipped
with a right adjoint $f_\*: E\to F$.  A 2-morphism $f\to g$ is given by a
natural transformation $f^\*\to g^\*$.

Let $f : E \to F$ be a morphism of geometric universes; the properties of such
a morphism are profitably accessed through its *gluing fibration* $\GL{f}$ over $E$.
«
  \DiagramSquare{
    ne = \SelfIx{F},
    nw = \GL{f},
    se = F,
    sw = E,
    south = f^*,
    nw/style = pullback,
    height = 1.5cm,
    east/style = lies over,
    west/style = lies over,
  }
»

There is another fibration that will also be of use in some cases, such as
the theory of realizability. This is the *relative scone* or *inverted
gluing* fibration $\OpGL{f}$ over $F$:
«
  \DiagramSquare{
    ne = \SelfIx{E},
    nw = \OpGL{f},
    se = E,
    sw = F,
    south = f_*,
    nw/style = pullback,
    height = 1.5cm,
    east/style = lies over,
    west/style = lies over,
  }
»


## Topoi in a geometric universe

Let $E$ be a geometric universe. A $E$-*topos* $X$ or a *topos in
$E$* is defined to be a geometric universe $\Sh{X}$ equipped with a structure
map $X:E\to\Sh{X}$ whose gluing fibration $\GL{X}$ has a
generating family. A morphism of $E$-topoi $f:{X}\to{Y}$ is defined by a
morphism $\Sh{f}:\Sh{Y}\to\Sh{X}$ of geometric universes equipped with
a 2-isomorphism $\phi_{f}:\Sh{f}\circ Y\cong X$ in $[E,\Sh{X}]$.
«
    \begin{tikzpicture}[diagram]
      \node (E) {$E$};
      \node (S/Y) [below left = of E] {$\Sh{Y}$};
      \node (S/X) [below right = of E] {$\Sh{X}$};
      \draw[->] (E) to node [sloped,above] {$Y$} (S/Y);
      \draw[->] (S/Y) to node (S/f) [below] {$\Sh{f}$} (S/X);
      \draw[->] (E) to node [sloped,above] {$X$} (S/X);
      \node [between = E and S/f] {$\phi_{f}$};
    \end{tikzpicture}
»

A 2-morphism $\alpha:{f}\to{g}$ in $[X,Y]$ is defined to be a
2-morphism $\alpha:\Sh{f}\to{\Sh{g}}$ compatible with $\phi_{f},\phi_{g}$
in the sense that the following pasting diagrams are equal:
«
  \begin{tikzpicture}[diagram,baseline=(S/X.base)]
    \node (E) {$E$};
    \node (S/Y) [below left = of E] {$\Sh{Y}$};
    \node (S/X) [below right = of E] {$\Sh{X}$};
    \draw[->] (E) to node [sloped,above] {$Y$} (S/Y);
    \draw[->] (S/Y) to node (S/f) [upright desc] {$\Sh{f}$} (S/X);
    \draw[->] (E) to node [sloped,above] {$X$} (S/X);
    \draw[->,bend right=60] (S/Y) to node (S/g) [below] {$\Sh{g}$} (S/X);
    \node [between = E and S/f] {$\phi_{f}$};
    \node [between = S/g.north and S/f] {$\alpha$};
  \end{tikzpicture}
  \qquad
  \begin{tikzpicture}[diagram,baseline=(S/X.base)]
    \node (E) {$E$};
    \node (S/Y) [below left = of E] {$\Sh{Y}$};
    \node (S/X) [below right = of E] {$\Sh{X}$};
    \draw[->] (E) to node [sloped,above] {$Y$} (S/Y);
    \draw[->] (E) to node [sloped,above] {$X$} (S/X);
    \draw[->,bend right=60] (S/Y) to node (S/g) [below] {$\Sh{g}$} (S/X);
    \node [between = S/Y and S/X] {$\phi_g$};
  \end{tikzpicture}
»

We will write $\TOP{E}$ for the (very large) bicategory of $E$-topoi.
