---
layout: post
title: Foundations of relative category theory
macrolib: topos
usemathjax: true
date: 2022-01-01
antex:
  preamble: >-
    \usepackage{jon-tikz}
    \usepackage{mlmodern,amsfonts,amssymb,amsmath}
    \usepackage{topos}
---

We assume knowledge of basic categorical concepts such as categories, functors,
and natural transformations. The purpose of this lecture is to develop the
notion of a category *over* another category.

We will draw on the following materials:

> - Ahrens and Lumsdaine {%cite ahrens-lumsdaine:2019 -A%}. [Displayed Categories](https://arxiv.org/abs/1705.04296).
> - Borceux {%cite borceux:1994:vol2 -A%}. Handbook of Categorical Algebra 2: Categories and Structures.
> - Jacobs {%cite jacobs:1999 -A%}.  [Categorical Logic and Type Theory](https://people.mpi-sws.org/~dreyer/courses/catlogic/jacobs.pdf) .
> - Streicher {%cite streicher:2021:fib -A%}. [Fibered Categories à la Jean Bénabou](https://www2.mathematik.tu-darmstadt.de/~streicher/FIBR/FiBo.pdf).

{% include toc.html %}


## Displayed categories and fibrations

Let $B$ be a category. A *displayed category* $E$ over $B$ is defined by the
following data:
1. for each object $x\in B$, a collection of *displayed objects* $E_x$,
2. for each morphism $f : x \to y\in B$ and displayed objects $\dot{x}\in E_x$ and
   $\dot{y}\in E_y$, a family of collections of *displayed morphisms* $E_f(\dot{x},\dot{y})$,
3. for each $x\in B$ and $\dot{x}\in E_x$, a morphism $\Idn{\dot{x}} \in
   E\Sub{\Idn{x}}(\dot{x},\dot{x})$ which we may also write $\dot{f}:\dot{x}\to_f \dot{y}$,
4. for each $f : x \to y$ and $g:y \to z$ in $B$ and objects $\dot{x}\in E_x, \dot{y}\in
   E_y, \dot{z}\in E_z$, a function
    \\[
      E_f(\dot{x},\dot{y}) \times E_g(\dot{y},\dot{z}) \to E_{f;g}(\dot{x},\dot{z})
    \\]
   that we will denote like ordinary (digrammatic) function composition,
5. such that the following equations hold:
  \\[
      \Idn{\dot{x}};\dot{h} = \dot{h}\qquad
      \dot{h};\Idn{\dot{y}} = \dot{h}\qquad
      \dot{f};(\dot{g};\dot{h}) = (\dot{f};\dot{g});\dot{h}
  \\]
Note that these are well-defined because of the corresponding
laws for the base category $B$.


**Notation**. When we have too many subscripts, $E[x]$ instead of $E_x$.


### Cartesian morphisms

Let $E$ be displayed over $B$, and let $f:x\to y \in B$; a morphism
$\dot{f}:\dot{x}\to_f \dot{y}$ in $E$ is called *cartesian* over $f$ when for
any $m:u\to x$ and $\dot{h}:\dot{u}\to_{u;f} \dot{y}$ there exists a unique
$\dot{m} : \dot{u}\to_m \dot{x}$ with $\dot{m};\dot{f} = \dot{h}$. We visualize
this unique factorization of $\dot{h}$ through $\dot{f}$ over $m$ as follows:
«
  \begin{tikzpicture}[diagram]
    \SpliceDiagramSquare{
      west/style = lies over,
      east/style = lies over,
      north/node/style = upright desc,
      height = 1.5cm,
      nw = \dot{x},
      ne = \dot{y},
      sw = x,
      north = \dot{f},
      south = f,
      se = y,
    }
    \node (u') [above left = 1.5cm of nw,xshift=-.5cm] {$\dot{u}$};
    \node (u) [above left = 1.5cm of sw,xshift=-.5cm] {$u$};
    \draw[lies over] (u') to (u);
    \draw[->,bend left=30] (u') to node [sloped,above] {$\dot{h}$} (ne);
    \draw[->] (u) to node [sloped,below] {$m$} (sw);
    \draw[->,exists] (u') to node [desc] {$\dot{m}$} (nw);
  \end{tikzpicture}
»


### Cartesian fibrations

A displayed category $E$ over $B$ is said to be a *cartesian fibration*, when
for each morphism $f : x \to y$ and displayed object $\dot{y}\in E_y$, there
exists a displayed object $\dot{x}\in E_x$ and a *cartesian* morphism
$\dot{f} : \dot{x}\to\Sub{f} \dot{y}$. Note that the pair $(\dot{x},\dot{f})$ is unique up to
unique isomorphism, so being fibered is a *property* of a displayed category.

There are other variations of fibration. For instance, $E$ is said to be an
*isofibration* when the condition above holds just for isomorphisms $f : x
\cong y$ in the base.

### Example: the canonical self-indexing

Let $B$ be an ordinary category; there is a canonical displayed category
$\SelfIx{B}$ over $B$ given fiberwise by the *slices* of $B$.
1. For $x\in B$, we define $\SelfIx{B}\Sub{x}$ to be the collection $\Sl{B}{x}$
   of pairs $(\dot{x}\in B,p_x:\dot{x}\to x)$.
2. For $f : x\to y\in B$, we define $\SelfIx{B}\Sub{f}$ to be the collection of
   commuting squares in the following configuration:
«
  \DiagramSquare{
    height = 1.7cm,
    nw = \dot{x},
    ne = \dot{y},
    sw = x,
    se = y,
    west = p_x,
    east = p_y,
    south = f,
    north = \dot{f},
    west/style = exists,
    east/style = exists,
    north/style = exists,
  }
»

**Exercise.** Prove that $\SelfIx{B}$ is a cartesian fibration if and only if $B$ has pullbacks.


### Example: the family fibration as a basis for relative category theory {#ex:family-fibration}

Any ordinary category $C$ can be viewed as a displayed category $\FAM{C}$ over $\SET$:

1. For $S\in \SET$, object in $\FAM{C}[S]$ is specified by a functor $C^S$
   where $S$ is regarded as a discrete category.
2. Given $f : S \to T$ in $\SET$ and $x\in C^S$ and $y\in C^T$, a morphism
   $x \to\Sub{f} y$ is given by a morphism $\InvImg{f}x\to y$ in $C^S$ where
   $\InvImg{f} : C^T \to C^S$ is precomposiiton with $f$.

The displayed category $\FAM{C}$ is in fact a cartesian fibration. This family
fibration is the starting point for developing a *relative* form of category
theory, the purpose of this lecture. By analogy with viewing an ordinary
category $C$ as a fibration $\FAM{C}$ over $\SET$, we may reasonably define a
"relative category" over another base $B$ to be a fibration over $B$.

This story for relative category theory reflects the way that ordinary
categories are "based on" $\SET$ in some sense in spite of the fact that they
do not necessarily have sets of objects or even sets of morphisms between
objects. Being small and locally small respectively will later be seen to be
properties of a family fibration over an arbitrary base $B$, strictly
generalizing the classical notions.


### Fiber categories and vertical maps

Let $E$ be a category displayed over $B$. A *vertical map* in $E$ is defined to be one that
lies over the identity map in $B$.
For every $b\in B$, there the collection $E_b$ of displayed objects has the
structure of a category; in particular, we set $E_b(u,v)$ to be the collection
of vertical maps $u\to\Sub{\Idn{b}}v$.


### Displayed and fibered functors

Let $E$ be displayed over $B$ and let $F$ be displayed over $C$. If $U:B \to C$
is an ordinary functor, than a *displayed functor* from $E$ to $F$ over $U$ is
given by the following data:

1. for each displayed object $\dot{x}\in E\Sub{x}$, a displayed object $\dot{U}\dot{x}\in E\Sub{Ux}$,
2. for each displayed morphism $\dot{f} : \dot{x}\to\Sub{f}\dot{y}$, a displayed morphism $\dot{U}\dot{f} : \dot{U}\dot{x}\to\Sub{Uf}\dot{U}\dot{y}$,
3. such that the assignment $\dot{U}f$ preserves displayed identities and displayed composition.

From this notion, we can see the varition of displayed categories over their
base categories itself has a "displayed categorical" structure; up to size
issues, we could speak of the displayed *bicategory* of displayed categories.

**Note.** The correct notion of morphism between cartesian fibrations is given
by displayed functors that preserve cartesian maps. We will call these *fibered
functors*.

### Change of base {#base-change}

Suppose that $E$ is displayed over $B$ and $F : X\to B$ is a
functor; then we may define a displayed category $\InvImg{F}E$ as over $X$ follows:

1. An object of $(\InvImg{F}E)\Sub{x}$ is an object of $E\Sub{Fx}$.

2. Given $\dot{x}\in (\InvImg{F}E)\Sub{x}$, $\dot{y}\in (\InvImg{F}E)\Sub{y}$ and $f : x
   \to y$, a morphism $\dot{x}\to\Sub{f}\dot{y}$ in $\InvImg{F}E$ is given by a morphism $\dot{x}\to\Sub{Ff}\dot{y}$ in $E$.

We visualize the change of base scenario as follows:
«
\DiagramSquare{
  nw/style = pullback,
  west/style = lies over,
  east/style = lies over,
  height = 1.5cm,
  nw = \InvImg{F}{E},
  ne = E,
  sw = X,
  se = B,
  south = F,
}
»


## The Grothendieck construction

### The total category and its projection

Note that any displayed category $E$ over $B$ can be viewed as an undisplayed
category $\TotCat{E}$ equipped with a projection functor $p_E: \TotCat{E}\to
B$; in this case $\TotCat{E}$ is called the *total category* of $E$.

1. An object of $\TotCat{E}$ is given by a pair $(x,\dot{x})$ where $x\in B$ and
   $\dot{x}\in E_x$.
2. A morphism $(x,\dot{x})\to (y,\dot{y})$ in $\TotCat{E}$ is given by a pair $(f,\dot{f})$ where
   $f:x\to y$ and $\dot{f}:\dot{x}\to_f\dot{y}$.

The construction of the total category of displayed category is called the *Grothendieck construction.*

**Exercise.** Prove that the total category $\TotCat{\SelfIx{B}}$ of the canonical self-indexing is the arrow category $B^{\to}$.


### Displayed categories from functors {#displayed-cats-from-functors}

In many cases, one starts with a functor $P:E\to B$; if it were meaningful to
speak of *equality* of objects in an arbitrary category then there would be an
obvious construction of a displayed category $P_\bullet$ from $P$; we would
simply set $P_x$ to be the collection of objects $u\in E$ such that $Pu=x$. As
it stands there is a more subtle version that will coincide up to categorical
equivalence with the naïve one in all cases that the latter is meaningful.

1. We define an object of $P_x$ to be be a pair $(u,\phi_u)$ where $i\in E$ and
   $\phi_u : Pu\cong x$. It is good to visualize such a pair as a "crooked
   leg" like so:
«
\begin{tikzpicture}[diagram]
\node (u) {$u$};
\node (Pu) [below = 1cm of u] {$Pu$};
\node (x) [right = 1.5cm of Pu] {$x$};
\draw[lies over] (u) to (Pu);
\draw[->] (Pu) to node [below] {$\phi_u$} (x);
\end{tikzpicture}
»

2. A morphism $(u,\phi_u)\to\Sub{f} (v,\phi_v)$ over $f : x \to y$ is given by
   a morphism $h : u\to v$ that lies over $f$ modulo the isomorphisms
   $\phi_u,\phi_v$ in sense depicted below:
«
\begin{tikzpicture}[diagram]
\node (pu) {$Pu$};
\node (pv) [right = of pu] {$Pv$};
\node (x) [below left = 1.5cm of pu] {$x$};
\node (y) [below right = 1.5cm of pv] {$y$};
\node (u) [above = 1.5cm of pu] {$u$};
\node (v) [above = 1.5cm of pv] {$v$};
\draw[lies over] (u) to (pu);
\draw[lies over] (v) to (pv);
\draw[->] (u) to node [above] {$h$} (v);
\draw[->] (x) to node [sloped,above] {$\phi_u\Sup{-1}$} (pu);
\draw[->] (pu) to node [upright desc] {$Ph$} (pv);
\draw[->] (pv) to node [sloped,above] {$\phi_v$} (y);`
\draw[->,bend right=30] (x) to node [below] {$f$} (y);
\end{tikzpicture}
»

**Exercise.** Suppose that $B$ is an internal category in $\mathbf{Set}$, i.e.
it has a set of objects. Exhibit an equivalence of displayed categories between
$P_\bullet$ as described above, and the naïve definition which $E_x$ is the
collection of objects $u\in E$ such that $Pu = x$.


We have a functor $\TotCat{P_\bullet}\to E$ taking a pair $(x,(u,\phi_u))$ to
$u$.

**Exercise.** Explicitly construct the functorial action of $\TotCat{P_\bullet}\to E$.

**Exercise.** Verify that $\TotCat{P_\bullet}\to E$ is a categorical equivalence.

#### Relation to Street's fibrations

In classical category theory, fibrations are defined by
Grothendieck to be certain functors $E\to B$ such that any morphism $f:x\to Pv$
in $B$ lies strictly underneath a cartesian morphism in $E$. As we have
discussed, this condition cannot be formulated unless equality is meaningful
for the collection of objects of $B$.

There is an alternative definition of fibration due to Street that avoids
equality of objects; here we require for each $f:x\to Pv$ a cartesian morphism
$h:\InvImg{f}v \to v$ together with an isomorphism $\phi : \InvImg{f}v\cong x$
such that $P(\phi^{-1};h) = f$.

By unrolling definitions, it is not difficult to see that the displayed
category $P_\bullet$ is a fibration in our sense if and only if the functor
$P:E\to B$ was a fibration in Street's sense. Moreover, it can be seen that the
Grothendieck construction yields a *Grothendieck* fibration
$\TotCat{P_\bullet}\to B$; hence we have introduced by accident a convenient
destription of the *strictification* of Street fibrations into equivalent
Grothendieck fibrations.


### Iteration and pushforward

It also makes sense to speak of a categories displayed over other displayed
categories; one way to formalize this notion is as follows. Let $E$ be
displayed over $B$; we define a category displayed over $E$ to be simply a
category displayed over the total category $\TotCat{E}$.

Now let $F$ be displayed over $E$ over $B$. Then we may regard $F$ as a
displayed category $B\Sub{!}F$ over $B$ as follows:

1. An object of $(B\Sub{!}F)\Sub{x}$ is a pair $(\dot{x},{\ddot{x}})$ with $\dot{x}\in E\Sub{x}$ and ${\ddot{x}}\in F\Sub{\dot{x}}$.
2. A morphism $(\dot{x},{\ddot{x}})\to\Sub{f}(\dot{y},{\ddot{y}})$ is given by a pair $(\dot{f},{\ddot{f}})$ where $\dot{f}:\dot{x}\to\Sub{f}\dot{y}$ in $E$ and ${\ddot{f}}:{\ddot{x}}\to\Sub{\dot{f}} {\ddot{y}}$ in $F$.

By virtue of the [above](#displayed-cats-from-functors), we may define the
*pushforward* of a displayed category along a functor. In particular, let $E$
be displayed over $B$ and let $U:B\to C$ be an ordinary functor; then we may
obtain a displayed category $U\Sub{!}E$ over $C$ as follows:

1. First we construct the displayed category $U_\bullet$ corresponding to the
   functor $U:B \to C$.
2. We recall that there is a canonical equivalence of categories
   $\TotCat{U_\bullet}\to B$.
3. Because $E$ is displayed over $B$, we may regard it as displayed over the
   equivalent total category $\TotCat{U_\bullet}$ by [change of base](#base-change).
4. Hence we may define the pushforward $U\Sub{!}E$ to be the displayed category $(U_\bullet)\Sub{!}E$ as defined above.


## Properties of fibrations


### Locally small fibrations

#### Warmup: locally small family fibrations

An ordinary category $E$ is called *locally small* when for any $x,y\in E$ the
collection of morphisms $x\to y$ is a set.  This property of $E$ can be
rephrased in terms of its [*family fibration*](#ex:family-fibration) $\FAM{E}$ over
$\SET$ as follows.

Consider an index set $I\in \SET$ and two families $u,v\in C^I$. We may define
an $I$-indexed collection $[u,v]\Sub{i\in I}$ consisting (pointwise) of all the
morphisms $u_i\to v_i$ in $C$:
\\[
  [u,v]\Sub{i} = \\{ f \mid f: u_i\to v_i \\}
\\]

If $C$ is locally small, $[u,v]\Sub{i\in I}$ is in fact a family of sets for
any $I\in\SET$ as each $[u,v]_i$ is a set. Conversely, if $[u,v]\Sub{i\in I}$
is a family of sets for any $I\in \SET$, then $C$ is locally small as we may
consider in particular the case that $I=\mathbf{1}$.

#### A more abstract formulation

We will reformulate the above in a way that uses only the language that makes
sense for an arbitrary fibration, though for now we stick with $\FAM{C}$.

1. Given $u,v\in \FAM{C}[I]$, we have a "relative hom family" $[u,v]\in\Sl{\SET}{I}$, defined as above.

2. The fact that each $[u,v]_i$ is the set of all morphisms $u_i\to v_i$ can be
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
         north = \dot{p}\Sub{[u,v]}
       }
       »
       Explicitly the family $\InvImg{[u,v]}u$ is indexed in a pair of an element $i\in I$ and a morphism $u_i\to v_i$.
       Informally we can think of $\InvImg{[u,v]}u$ as the object of elements of $u_i$ indexed in pairs $(u,u_i\to v_i)$.

    + There is a canonical map
      $\epsilon\Sub{[u,v]}:\InvImg{[u,v]}u\to\Sub{p\Sub{[u,v]}} v$ that
      "evaluates" each indexing morphism $u_i\to v_i$.

    + That each $[u,v]_i$ is the set of all morphisms $u_i\to v_i$ can be
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
        \draw[bend left,->] (h/u) to node [sloped,above] {$\epsilon_h$} (ne);
        \draw[lies over] (h/u) to (h);
        \draw[->,exists] (h) to (sw);
        \draw[->,exists] (h/u) to (nw);
        \draw[->,bend right=30] (h) to node [below] {$p_h$} (se);
      \end{tikzpicture}
      »

#### The definition of local smallness

Based on our explorations above, we are now prepared to write down (and
understand) the proper definition of local smallness for an arbitrary fibration
$E$ over $B$, which should be thought of as a (potentially large) category
relative to $B$.

For any $x\in B$ and displayed objects $u,v\in E_x$, we define a *hom
candidate* for $u,v$ to be a span $u\leftarrow \dot{h} \rightarrow v$ in $E$ in which the left-hand leg is cartesian:
«
\begin{tikzpicture}[diagram]
\SpliceDiagramSquare<l/>{
  height = 1.5cm,
  west/style = lies over,
  east/style = lies over,
  north/style = <-,
  south/style = <-,
  ne/style = ne pullback,
  ne = \dot{h},
  se = h,
  sw = x,
  nw = u,
  south = p_h,
  north = \dot{p}_h
}
\SpliceDiagramSquare<r/>{
  height = 1.5cm,
  west/style = lies over,
  east/style = lies over,
  glue = west,
  glue target = l/,
  ne = v,
  se = x,
  north = \epsilon_h,
  south = p_h,
}
\end{tikzpicture}
»

In the above, $h$ should be thought of as a candidate for the "hom object" of $u,v$,
and $\epsilon_h$ should be viewed as the structure of an "evaluation map" for $h$.
This structure can be rephrased in terms of a displayed category $\CandHom{x}{u}{v}$ over $\Sl{B}{x}$:

1. Given $h\in \Sl{B}{x}$, an object of $\CandHom{x}{u}{v}\Sub{h}$ is given by a hom candidate
   whose apex in the base is $h$ itself. We will write $\dot{h}$ metonymically
   for the entire hom candidate over $h$.

2. Given $\alpha:l\to h\in\Sl{B}{x}$ and hom candidates $\dot{l}\in \CandHom{x}{u}{v}\Sub{l}$ and
   $\dot{h}\in \CandHom{x}{u}{v}\Sub{h}$, a morphism $\dot{h}\to\Sub{\alpha} \dot{l}$ is given by a
   cartesian morphism $\dot\alpha:\dot{l}\to\Sub{\alpha}\dot{h}$ in $E$ such that the
   following diagram commutes:
   «
   \begin{tikzpicture}[diagram]
     \node (u) {$u$};
     \node (l) [above right = 1.5cm of u,xshift=.5cm] {$\dot{l}$};
     \node (h) [below right = 1.5cm of u,xshift=.5cm] {$\dot{h}$};
     \node (v) [below right = 1.5cm of l,xshift=.5cm] {$v$};
     \draw[->] (h) to node [sloped,below] {$\dot{p}_h$} (u);
     \draw[->] (l) to node [sloped,above] {$\dot{p}_l$} (u);
     \draw[->] (h) to node [sloped,below] {$\epsilon_h$} (v);
     \draw[->] (l) to node [sloped,above] {$\epsilon_l$} (v);
     \draw[->] (l) to node [upright desc] {$\dot\alpha$} (h);
   \end{tikzpicture}
   »

**Definition.** A fibration $E$ over $B$ is *locally small* if and only if for
each $x\in B$ and $u,v\in E_x$, the total category $\TotCat{\CandHom{x}{u}{v}}$
has a terminal object.


### Generic objects [todo]

### Internal categories [todo]

### Generating families [todo]

### Definable classes [todo]

## Bibliography
{%bibliography --cited%}
