---
layout: page
title: Foundations of Relative Category Theory I
subtitle: Displayed categories and fibrations
label: rct1
macrolib: topos
usemathjax: true
date: 2022-01-01
antex:
  preamble: >-
    \usepackage{jon-tikz}
    \usepackage{mlmodern,amsfonts,amssymb,amsmath}
    \usepackage{topos}
---

{{page.jon}}

We assume knowledge of basic categorical concepts such as categories, functors,
and natural transformations. The purpose of this lecture is to develop the
notion of a category *over* another category.

We will draw on the following materials:

> - Ahrens and Lumsdaine {%cite ahrens-lumsdaine:2019 -A%}. [Displayed Categories](https://arxiv.org/abs/1705.04296).
> - Benabou {%cite benabou:1985 -A%}. Fibered categories and the foundations of naive category theory.
> - Borceux {%cite borceux:1994:vol2 -A%}. Handbook of Categorical Algebra 2: Categories and Structures.
> - Jacobs {%cite jacobs:1999 -A%}.  [Categorical Logic and Type Theory](https://people.mpi-sws.org/~dreyer/courses/catlogic/jacobs.pdf) .
> - Streicher {%cite streicher:2021:fib -A%}. [Fibered Categories à la Jean Bénabou](https://www2.mathematik.tu-darmstadt.de/~streicher/FIBR/FiBo.pdf).

{% include toc.html %}


## Displayed categories

Let $B$ be a category. A *displayed category* $E$ over $B$ is defined by the
following data:
1. for each object $x\in B$, a collection of *displayed objects* $E\Sub{x}$,
2. for each morphism $f : x \to y\in B$ and displayed objects $\bar{x}\in E\Sub{x}$ and
   $\bar{y}\in E\Sub{y}$, a family of collections of *displayed morphisms* $E\Sub{f}(\bar{x},\bar{y})$,
3. for each $x\in B$ and $\bar{x}\in E\Sub{x}$, a morphism $\Idn{\bar{x}} \in
   E\Sub{\Idn{x}}(\bar{x},\bar{x})$ which we may also write $\bar{f}:\bar{x}\to\Sub{f} \bar{y}$,
4. for each $f : x \to y$ and $g:y \to z$ in $B$ and objects $\bar{x}\in E\Sub{x}, \bar{y}\in
   E\Sub{y}, \bar{z}\in E\Sub{z}$, a function
    \\[
      E\Sub{f}(\bar{x},\bar{y}) \times E\Sub{g}(\bar{y},\bar{z}) \to E\Sub{f;g}(\bar{x},\bar{z})
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


**Notation**. When we have too many subscripts, $E[x]$ instead of $E\Sub{x}$.


## Cartesian morphisms

Let $E$ be displayed over $B$, and let $f:x\to y \in B$; a morphism
$\bar{f}:\bar{x}\to\Sub{f} \bar{y}$ in $E$ is called *cartesian* over $f$ when for
any $m:u\to x$ and $\bar{h}:\bar{u}\to\Sub{u;f} \bar{y}$ there exists a unique
$\bar{m} : \bar{u}\to\Sub{m} \bar{x}$ with $\bar{m};\bar{f} = \bar{h}$. We visualize
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
      nw/style = pullback,
    }
    \node (u') [above left = 1.5cm of nw,xshift=-.5cm] {$\bar{u}$};
    \node (u) [above left = 1.5cm of sw,xshift=-.5cm] {$u$};
    \draw[lies over] (u') to (u);
    \draw[->,bend left=30] (u') to node [sloped,above] {$\bar{h}$} (ne);
    \draw[->] (u) to node [sloped,below] {$m$} (sw);
    \draw[->,exists] (u') to node [desc] {$\bar{m}$} (nw);
  \end{tikzpicture}
»

Above we have used the "pullback corner" to indicate $\bar{x}\to\bar{y}$ as a cartesian map. We return to this in our discussion of the [self-indexing](#self-indexing) of a category.


## Cartesian fibrations

A displayed category $E$ over $B$ is said to be a *cartesian fibration*, when
for each morphism $f : x \to y$ and displayed object $\bar{y}\in E\Sub{y}$, there
exists a displayed object $\bar{x}\in E\Sub{x}$ and a *cartesian* morphism
$\bar{f} : \bar{x}\to\Sub{f} \bar{y}$. Note that the pair $(\bar{x},\bar{f})$ is unique up to
unique isomorphism, so being fibered is a *property* of a displayed category.

There are other variations of fibration. For instance, $E$ is said to be an
*isofibration* when the condition above holds just for isomorphisms $f : x
\cong y$ in the base.

## Example: the canonical self-indexing {#self-indexing}

Let $B$ be an ordinary category; there is a canonical displayed category
$\SelfIx{B}$ over $B$ given fiberwise by the *slices* of $B$.
1. For $x\in B$, we define $\SelfIx{B}\Sub{x}$ to be the collection $\Sl{B}{x}$
   of pairs $(\bar{x}\in B,p\Sub{x}:\bar{x}\to x)$.
2. For $f : x\to y\in B$, we define $\SelfIx{B}\Sub{f}$ to be the collection of
   commuting squares in the following configuration:
«
  \DiagramSquare{
    height = 1.7cm,
    nw = \bar{x},
    ne = \bar{y},
    sw = x,
    se = y,
    west = p\Sub{x},
    east = p\Sub{y},
    south = f,
    north = \bar{f},
    west/style = exists,
    east/style = exists,
    north/style = exists,
  }
»

**Exercise.** Prove that $\SelfIx{B}$ is a cartesian fibration if and only if $B$ has pullbacks.


## Example: the family fibration as a basis for relative category theory {#ex:family-fibration}

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


## Fiber categories and vertical maps

Let $E$ be a category displayed over $B$. A *vertical map* in $E$ is defined to be one that
lies over the identity map in $B$.
For every $b\in B$, there the collection $E\Sub{b}$ of displayed objects has the
structure of a category; in particular, we set $E\Sub{b}(u,v)$ to be the collection
of vertical maps $u\to\Sub{\Idn{b}}v$.


## Displayed and fibered functors

Let $E$ be displayed over $B$ and let $F$ be displayed over $C$. If $U:B \to C$
is an ordinary functor, than a *displayed functor* from $E$ to $F$ over $U$ is
given by the following data:

1. for each displayed object $\bar{x}\in E\Sub{x}$, a displayed object $\bar{U}\bar{x}\in E\Sub{Ux}$,
2. for each displayed morphism $\bar{f} : \bar{x}\to\Sub{f}\bar{y}$, a displayed morphism $\bar{U}\bar{f} : \bar{U}\bar{x}\to\Sub{Uf}\bar{U}\bar{y}$,
3. such that the assignment $\bar{U}f$ preserves displayed identities and displayed composition.

From this notion, we can see the varition of displayed categories over their
base categories itself has a "displayed categorical" structure; up to size
issues, we could speak of the displayed *bicategory* of displayed categories.

**Note.** The correct notion of morphism between cartesian fibrations is given
by displayed functors that preserve cartesian maps. We will call these *fibered
functors*.

## Change of base {#base-change}

Suppose that $E$ is displayed over $B$ and $F : X\to B$ is a
functor; then we may define a displayed category $\InvImg{F}E$ as over $X$ follows:

1. An object of $(\InvImg{F}E)\Sub{x}$ is an object of $E\Sub{Fx}$.

2. Given $\bar{x}\in (\InvImg{F}E)\Sub{x}$, $\bar{y}\in (\InvImg{F}E)\Sub{y}$ and $f : x
   \to y$, a morphism $\bar{x}\to\Sub{f}\bar{y}$ in $\InvImg{F}E$ is given by a morphism $\bar{x}\to\Sub{Ff}\bar{y}$ in $E$.

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


## Bibliography
{%bibliography --cited%}
