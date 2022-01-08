---
layout: page
title: Foundations of Relative Category Theory II
subtitle: The Grothendieck construction
macrolib: topos
usemathjax: true
date: 2022-01-02
antex:
  preamble: >-
    \usepackage{jon-tikz}
    \usepackage{mlmodern,amsfonts,amssymb,amsmath}
    \usepackage{topos}
---

{% include toc.html %}

## The total category and its projection

Note that any displayed category $E$ over $B$ can be viewed as an undisplayed
category $\TotCat{E}$ equipped with a projection functor $p\Sub{E}: \TotCat{E}\to
B$; in this case $\TotCat{E}$ is called the *total category* of $E$.

1. An object of $\TotCat{E}$ is given by a pair $(x,\bar{x})$ where $x\in B$ and
   $\bar{x}\in E\Sub{x}$.
2. A morphism $(x,\bar{x})\to (y,\bar{y})$ in $\TotCat{E}$ is given by a pair $(f,\bar{f})$ where
   $f:x\to y$ and $\bar{f}:\bar{x}\to\Sub{f}\bar{y}$.

The construction of the total category of displayed category is called the *Grothendieck construction.*

**Exercise.** Prove that the total category $\TotCat{\SelfIx{B}}$ of the canonical self-indexing is the arrow category $B^{\to}$.


## Displayed categories from functors {#displayed-cats-from-functors}

In many cases, one starts with a functor $P:E\to B$; if it were meaningful to
speak of *equality* of objects in an arbitrary category then there would be an
obvious construction of a displayed category $P\Sub{\bullet}$ from $P$; we would
simply set $P\Sub{x}$ to be the collection of objects $u\in E$ such that $Pu=x$. As
it stands there is a more subtle version that will coincide up to categorical
equivalence with the naïve one in all cases that the latter is meaningful.

1. We define an object of $P\Sub{x}$ to be be a pair $(u,\phi\Sub{u})$ where $i\in E$ and
   $\phi\Sub{u} : Pu\cong x$. It is good to visualize such a pair as a "crooked
   leg" like so:
«
\begin{tikzpicture}[diagram]
\node (u) {$u$};
\node (Pu) [below = 1cm of u] {$Pu$};
\node (x) [right = 1.5cm of Pu] {$x$};
\draw[lies over] (u) to (Pu);
\draw[->] (Pu) to node [below] {$\phi\Sub{u}$} (x);
\end{tikzpicture}
»

2. A morphism $(u,\phi\Sub{u})\to\Sub{f} (v,\phi\Sub{v})$ over $f : x \to y$ is given by
   a morphism $h : u\to v$ that lies over $f$ modulo the isomorphisms
   $\phi\Sub{u},\phi\Sub{v}$ in sense depicted below:
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
\draw[->] (x) to node [sloped,above] {$\phi\Sub{u}\Sup{-1}$} (pu);
\draw[->] (pu) to node [upright desc] {$Ph$} (pv);
\draw[->] (pv) to node [sloped,above] {$\phi\Sub{v}$} (y);
\draw[->,bend right=30] (x) to node [below] {$f$} (y);
\end{tikzpicture}
»

**Exercise.** Suppose that $B$ is an internal category in $\mathbf{Set}$, i.e.
it has a set of objects. Exhibit an equivalence of displayed categories between
$P\Sub{\bullet}$ as described above, and the naïve definition which $E\Sub{x}$ is the
collection of objects $u\in E$ such that $Pu = x$.


We have a functor $\TotCat{P\Sub{\bullet}}\to E$ taking a pair $(x,(u,\phi\Sub{u}))$ to
$u$.

**Exercise.** Explicitly construct the functorial action of $\TotCat{P\Sub{\bullet}}\to E$.

**Exercise.** Verify that $\TotCat{P\Sub{\bullet}}\to E$ is a categorical equivalence.

### Relation to Street's fibrations

In classical category theory, fibrations are defined by
Grothendieck {%cite sga:1 -A%} to be certain functors $E\to B$ such that any morphism $f:x\to Pv$
in $B$ lies strictly underneath a cartesian morphism in $E$. As we have
discussed, this condition cannot be formulated unless equality is meaningful
for the collection of objects of $B$.

There is an alternative definition of fibration {%cite street:1980%} that avoids
equality of objects; here we require for each $f:x\to Pv$ a cartesian morphism
$h:\InvImg{f}v \to v$ together with an isomorphism $\phi : P(\InvImg{f}v)\cong x$
such that $\phi^{-1};Ph = f$.

By unrolling definitions, it is not difficult to see that the displayed
category $P\Sub{\bullet}$ is a fibration in our sense if and only if the functor
$P:E\to B$ was a fibration in Street's sense. Moreover, it can be seen that the
Grothendieck construction yields a *Grothendieck* fibration
$\TotCat{P\Sub{\bullet}}\to B$; hence we have introduced by accident a convenient
destription of the *strictification* of Street fibrations into equivalent
Grothendieck fibrations.


## Iteration and pushforward

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

1. First we construct the displayed category $U\Sub{\bullet}$ corresponding to the
   functor $U:B \to C$.
2. We recall that there is a canonical equivalence of categories
   $\TotCat{U\Sub{\bullet}}\to B$.
3. Because $E$ is displayed over $B$, we may regard it as displayed over the
   equivalent total category $\TotCat{U\Sub{\bullet}}$ by
   [change of base]({{site.baseurl}}{%link _lectures/categorical-foundations-1.md%}#base-change).
4. Hence we may define the pushforward $U\Sub{!}E$ to be the displayed category $(U\Sub{\bullet})\Sub{!}E$ as defined above.


## Bibliography
{%bibliography --cited%}
