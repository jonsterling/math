---
layout: post
title: Categorical foundations (draft)
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
> - Jacobs {%cite jacobs:1999 -A%}.  [Categorical Logic and Type Theory](https://people.mpi-sws.org/~dreyer/courses/catlogic/jacobs.pdf) .
> - Streicher {%cite streicher:2021:fib -A%}. [Fibered Categories à la Jean Bénabou](https://www2.mathematik.tu-darmstadt.de/~streicher/FIBR/FiBo.pdf).

{% include toc.html %}


## Displayed categories and fibrations

Let $B$ be a category. A *displayed category* $E$ over $B$ is defined by the
following data:
1. for each object $x\in B$, a collection of *displayed objects* $E_x$,
2. for each morphism $f : x \to y\in B$ and displayed objects $\bar{x}\in E_x$ and
   $\bar{y}\in E_y$, a family of collections of *displayed morphisms* $E_f(\bar{x},\bar{y})$,
3. for each $x\in B$ and $\bar{x}\in E_x$, a morphism $\Idn{\bar{x}} \in
   E\Sub{\Idn{x}}(\bar{x},\bar{x})$ which we may also write $\bar{f}:\bar{x}\to_f \bar{y}$,
4. for each $f : x \to y$ and $g:y \to z$ in $B$ and objects $\bar{x}\in E_x, \bar{y}\in
   E_y, \bar{z}\in E_z$, a function
    \\[
      E_f(\bar{x},\bar{y}) \times E_g(\bar{y},\bar{z}) \to E_{f;g}(\bar{x},\bar{z})
    \\]
   that we will denote like ordinary (digrammatic) function composition,
5. such that the following equations hold:
  \\[
      \Idn{\bar{x}};\bar{h} = \bar{h}\qquad
      \bar{h};\Idn{\bar{y}} = \bar{h}\qquad
      \bar{f};(\bar{g};\bar{h}) = (\bar{f};\bar{g});\bar{h}
  \\]
Note that these are well-defined because of the corresponding
laws for the base category $B$.



### Cartesian morphisms

Let $E$ be displayed over $B$, and let $f:x\to y \in B$; a morphism
$\bar{f}:\bar{x}\to_f \bar{y}$ in $E$ is called *cartesian* over $f$ when for
any $m:u\to x$ and $\bar{h}:\bar{u}\to_{u;f} \bar{y}$ there exists a unique
$\bar{m} : \bar{u}\to_m \bar{x}$ with $\bar{m};\bar{f} = \bar{h}$. We visualize
this unique factorization of $\bar{h}$ through $\bar{f}$ over $m$ as follows:
«
  \begin{tikzpicture}[diagram]
    \SpliceDiagramSquare{
      west/style = lies over,
      east/style = lies over,
      north/node/style = upright desc,
      height = 1.5cm,
      nw = \bar{x},
      ne = \bar{y},
      sw = x,
      north = \bar{f},
      south = f,
      se = y,
    }
    \node (u') [above left = 1.5cm of nw,xshift=-.5cm] {$\bar{u}$};
    \node (u) [above left = 1.5cm of sw,xshift=-.5cm] {$u$};
    \draw[lies over] (u') to (u);
    \draw[->,bend left=30] (u') to node [sloped,above] {$\bar{h}$} (ne);
    \draw[->] (u) to node [sloped,below] {$m$} (sw);
    \draw[->,exists] (u') to node [desc] {$\bar{m}$} (nw);
  \end{tikzpicture}
»


### Cartesian fibrations

A displayed category $E$ over $B$ is said to be a *Cartesian fibration*, when
for each morphism $f : x \to y$ and displayed object $\bar{y}\in E_y$, there
exists a displayed object $\bar{x}\in E_x$ and a *cartesian* morphism
$\bar{f} : \bar{x}\to\Sub{f} \bar{y}$. Note that the pair $(\bar{x},\bar{f})$ is unique up to
unique isomorphism, so being fibered is a *property* of a displayed category.

There are other variations of fibration. For instance, $E$ is said to be an
*isofibration* when the condition above holds just for isomorphisms $f : x
\cong y$ in the base.

### The canonical self-indexing

Let $B$ be an ordinary category; there is a canonical displayed category
$\SelfIx{B}$ over $B$ given fiberwise by the *slices* of $B$.
1. For $x\in B$, we define $\SelfIx{B}\Sub{x}$ to be the collection $\Sl{B}{x}$
   of pairs $(\bar{x}\in B,p_x:\bar{x}\to x)$.
2. For $f : x\to y\in B$, we define $\SelfIx{B}\Sub{f}$ to be the collection of
   commuting squares in the following configuration:
«
  \DiagramSquare{
    height = 1.7cm,
    nw = \bar{x},
    ne = \bar{y},
    sw = x,
    se = y,
    west = p_x,
    east = p_y,
    south = f,
    north = \bar{f},
    west/style = exists,
    east/style = exists,
    north/style = exists,
  }
»

**Exercise.** Prove that $\SelfIx{B}$ is a Cartesian fibration if and only if $B$ has pullbacks.


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

1. for each displayed object $\bar{x}\in E\Sub{x}$, a displayed object $\bar{U}\bar{x}\in E\Sub{Ux}$,
2. for each displayed morphism $\bar{f} : \bar{x}\to\Sub{f}\bar{y}$, a displayed morphism $\bar{U}\bar{f} : \bar{U}\bar{x}\to\Sub{Uf}\bar{U}\bar{y}$,
3. such that the assignment $\bar{U}f$ preserves displayed identities and displayed composition.

From this notion, we can see the varition of displayed categories over their
base categories itself has a "displayed categorical" structure; up to size
issues, we could speak of the displayed *bicategory* of displayed categories.

**Note.** The correct notion of morphism between Cartesian fibrations is given
by displayed functors that preserve cartesian maps. We will call these *fibered
functors*.

### Change of base {#base-change}

Suppose that $E$ is displayed over $B$ and $F : X\to B$ is a
functor; then we may define a displayed category $\InvImg{X}E$ as over $X$ follows:

1. An object of $(\InvImg{X}E)\Sub{x}$ is an object of $E\Sub{Fx}$.

2. Given $\bar{x}\in (\InvImg{X}E)\Sub{x}$, $\bar{y}\in (\InvImg{X}E)\Sub{y}$ and $f : x
   \to y$, a morphism $\bar{x}\to\Sub{f}\bar{y}$ in $\InvImg{X}E$ is given by a morphism $\bar{x}\to\Sub{Ff}\bar{y}$ in $E$.

We visualize the change of base scenario as follows:
«
\DiagramSquare{
  nw/style = pullback,
  west/style = lies over,
  east/style = lies over,
  height = 1.5cm,
  nw = \InvImg{X}{E},
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

1. An object of $\TotCat{E}$ is given by a pair $(x,\bar{x})$ where $x\in B$ and
   $\bar{x}\in E_x$.
2. A morphism $(x,\bar{x})\to (y,\bar{y})$ in $\TotCat{E}$ is given by a pair $(f,\bar{f})$ where
   $f:x\to y$ and $\bar{f}:\bar{x}\to_f\bar{y}$.

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

1. An object of $(B\Sub{!}F)\Sub{x}$ is a pair $(\bar{x},{\ddot{x}})$ with $\bar{x}\in E\Sub{x}$ and ${\ddot{x}}\in F\Sub{\bar{x}}$.
2. A morphism $(\bar{x},{\ddot{x}})\to\Sub{f}(\bar{y},{\ddot{y}})$ is given by a pair $(\bar{f},{\ddot{f}})$ where $\bar{f}:\bar{x}\to\Sub{f}\bar{y}$ in $E$ and ${\ddot{f}}:{\ddot{x}}\to\Sub{\bar{f}} {\ddot{y}}$ in $F$.

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

### Locally small fibrations [todo]

### Generic objects [todo]

### Internal categories [todo]

### Generating families [todo]

### Definable classes [todo]

## Bibliography
{%bibliography --cited%}
