---
layout: page
title: Foundations of Relative Category Theory III
subtitle: Properties of fibrations
macrolib: topos
usemathjax: true
date: 2022-01-03
antex:
  preamble: >-
    \usepackage{jon-tikz}
    \usepackage{mlmodern,amsfonts,amssymb,amsmath}
    \usepackage{topos}
---

{% include toc.html %}

## Locally small fibrations

There are a number of (equivalent) variations on the definition of a locally
small fibration {%cite streicher:2021:fib borceux:1994:vol2 jacobs:1999%}. We attempt to provide
some intuition for these definitions.

### Warmup: locally small family fibrations

An ordinary category $E$ is called *locally small* when for any $x,y\in E$ the
collection of morphisms $x\to y$ is a set.  This property of $E$ can be
rephrased in terms of its [*family fibration*]({{site.baseurl}}{%link
_lectures/categorical-foundations-1.md%}#ex:family-fibration).  $\FAM{E}$ over
$\SET$ as follows.

Consider an index set $I\in \SET$ and two families $u,v\in C^I$. We may define
an $I$-indexed collection $[u,v]\Sub{i\in I}$ consisting (pointwise) of all the
morphisms $u\Sub{i}\to v\Sub{i}$ in $C$:
\\[
  [u,v]\Sub{i} = \\{ f \mid f: u\Sub{i}\to v\Sub{i} \\}
\\]

If $C$ is locally small, $[u,v]\Sub{i\in I}$ is in fact a family of sets for
any $I\in\SET$ as each $[u,v]\Sub{i}$ is a set. Conversely, if $[u,v]\Sub{i\in I}$
is a family of sets for any $I\in \SET$, then $C$ is locally small as we may
consider in particular the case that $I=\mathbf{1}$.

### A more abstract formulation

We will reformulate the above in a way that uses only the language that makes
sense for an arbitrary fibration, though for now we stick with $\FAM{C}$.

1. Given $u,v\in \FAM{C}[I]$, we have a "relative hom family" $[u,v]\in\Sl{\SET}{I}$, defined as above.

2. The fact that each $[u,v]\Sub{i}$ is the set of all morphisms $u\Sub{i}\to v\Sub{i}$ can be
   rephrased more abstractly.

    +  First we consider the restriction of $u\in \FAM{C}[I]$ to $\FAM{C}[[u,v]]$ as follows:
       «
       \DiagramSquare{
         nw/style = pullback,
         west/style = lies over,
         east/style = lies over,
         north/style = exists,
         height = 1.5cm,
         nw = \InvImg{[u,v]}u,
         ne = u,
         sw = {[u,v]},
         se = I,
         south = p\Sub{[u,v]},
         north = \bar{p}\Sub{[u,v]}
       }
       »
       Explicitly the family $\InvImg{[u,v]}u$ is indexed in a pair of an element $i\in I$ and a morphism $u\Sub{i}\to v\Sub{i}$.
       Informally we can think of $\InvImg{[u,v]}u$ as the object of elements of $u\Sub{i}$ indexed in pairs $(i,u\Sub{i}\to v\Sub{i})$.

    + There is a canonical map
      $\epsilon\Sub{[u,v]}:\InvImg{[u,v]}u\to\Sub{p\Sub{[u,v]}} v$ that
      "evaluates" each indexing morphism $u\Sub{i}\to v\Sub{i}$.

    + That each $[u,v]\Sub{i}$ is the set of all morphisms $u\Sub{i}\to v\Sub{i}$ can be
      rephrased as a universal property: for any family $h\in\Sl{\SET}{I}$ and
      morphism $\epsilon\Sub{h} : \InvImg{h}u\to\Sub{h} v$ in $\FAM{C}$, there is a
      unique cartesian map $\InvImg{h}u\to \InvImg{[u,v]}u$ factoring $\epsilon\Sub{h}$ through $\epsilon\Sub{[u,v]}$
      in the sense depicted below:
      «
      \begin{tikzpicture}[diagram]
        \SpliceDiagramSquare{
          height = 1.5cm,
          width = 3cm,
          west/style = lies over,
          east/style = lies over,
          north/node/style = upright desc,
          south/node/style = upright desc,
          nw = \InvImg{[u,v]}u,
          ne = v,
          sw = {[u,v]},
          se = I,
          south = p\Sub{[u,v]},
          north = \epsilon\Sub{[u,v]},
        }
        \node (h/u) [pullback,left = of nw] {$\InvImg{h}u$};
        \node (h) [left = of sw] {$h$};
        \draw[bend left,->] (h/u) to node [sloped,above] {$\epsilon\Sub{h}$} (ne);
        \draw[lies over] (h/u) to (h);
        \draw[->,exists] (h) to (sw);
        \draw[->,exists] (h/u) to (nw);
        \draw[->,bend right=30] (h) to node [below] {$p\Sub{h}$} (se);
      \end{tikzpicture}
      »

### The definition of local smallness

Based on our explorations above, we are now prepared to write down (and
understand) the proper definition of local smallness for an arbitrary fibration
$E$ over $B$, which should be thought of as a (potentially large) category
relative to $B$.

For any $x\in B$ and displayed objects $u,v\in E\Sub{x}$, we define a *hom
candidate* for $u,v$ to be a span $u\leftarrow \bar{h} \rightarrow v$ in $E$ in which the left-hand leg is cartesian:
«
\begin{tikzpicture}[diagram]
\SpliceDiagramSquare<l/>{
  height = 1.5cm,
  west/style = lies over,
  east/style = lies over,
  north/style = <-,
  south/style = <-,
  ne/style = ne pullback,
  ne = \bar{h},
  se = h,
  sw = x,
  nw = u,
  south = p\Sub{h},
  north = \bar{p}\Sub{h}
}
\SpliceDiagramSquare<r/>{
  height = 1.5cm,
  west/style = lies over,
  east/style = lies over,
  glue = west,
  glue target = l/,
  ne = v,
  se = x,
  north = \epsilon\Sub{h},
  south = p\Sub{h},
}
\end{tikzpicture}
»

In the above, $h$ should be thought of as a candidate for the "hom object" of $u,v$,
and $\epsilon\Sub{h}$ should be viewed as the structure of an "evaluation map" for $h$.
This structure can be rephrased in terms of a displayed category $\CandHom{x}{u}{v}$ over $\Sl{B}{x}$:

1. Given $h\in \Sl{B}{x}$, an object of $\CandHom{x}{u}{v}\Sub{h}$ is given by a hom candidate
   whose apex in the base is $h$ itself. We will write $\bar{h}$ metonymically
   for the entire hom candidate over $h$.

2. Given $\alpha:l\to h\in\Sl{B}{x}$ and hom candidates $\bar{l}\in \CandHom{x}{u}{v}\Sub{l}$ and
   $\bar{h}\in \CandHom{x}{u}{v}\Sub{h}$, a morphism $\bar{h}\to\Sub{\alpha} \bar{l}$ is given by a
   cartesian morphism $\bar\alpha:\bar{l}\to\Sub{\alpha}\bar{h}$ in $E$ such that the
   following diagram commutes:
   «
   \begin{tikzpicture}[diagram]
     \node (u) {$u$};
     \node (l) [above right = 1.5cm of u,xshift=.5cm] {$\bar{l}$};
     \node (h) [below right = 1.5cm of u,xshift=.5cm] {$\bar{h}$};
     \node (v) [below right = 1.5cm of l,xshift=.5cm] {$v$};
     \draw[->] (h) to node [sloped,below] {$\bar{p}\Sub{h}$} (u);
     \draw[->] (l) to node [sloped,above] {$\bar{p}\Sub{l}$} (u);
     \draw[->] (h) to node [sloped,below] {$\epsilon\Sub{h}$} (v);
     \draw[->] (l) to node [sloped,above] {$\epsilon\Sub{l}$} (v);
     \draw[->] (l) to node [upright desc] {$\bar\alpha$} (h);
   \end{tikzpicture}
   »

**Definition.** A fibration $E$ over $B$ is *locally small* if and only if for
each $x\in B$ and $u,v\in E\Sub{x}$, the total category $\TotCat{\CandHom{x}{u}{v}}$
has a terminal object.


## Generic objects [todo]

## Internal categories [todo]

## Generating families [todo]

## Definable classes [todo]


## Bibliography
{%bibliography --cited%}

