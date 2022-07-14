# Cheat Sheet

A cheat sheet for Agda (relative to VSCode with emacs mode on Windows).

- [Cheat Sheet](#cheat-sheet)
  - [Commands](#commands)
  - [Libraries](#libraries)
  - [Comparison with Haskell Syntax](#comparison-with-haskell-syntax)
  - [Comparison between Agda and Haskell Types](#comparison-between-agda-and-haskell-types)
    - [Haskell](#haskell)
    - [Agda](#agda)
  - [Dependent Types](#dependent-types)
  - [Connection between Agda and MLTT](#connection-between-agda-and-mltt)

## Commands

| Command | Description | 
| ------- | ------------ | 
| C-c C-l | Typecheck your file |
| C-c C-n | Normalize an expression |
| C-c C-t | Normalize a type |
| C-c C-c | Split case |
| C-c C-f | Move to next hole |
| C-c C-b | Move to previous hole |
| C-c C-, | Display goal and context |
| C-c C-r | Refine hole (Agda tries to fill it) |
| C-c C-space | Check current hole |


## Libraries

The modules that come with Agda (i.e., builtin and primitive, **not** 
the standard library) start
with an \<Agda.\> prefix.

The standard library modules do **not** have a \<Stdlib.\> prefix.

Cubical Agda modules **do** have a \<Cubical.\> prefix.

For documentation, I have the /Agda/ directory containing the builtin
and primitives, the /src/ directory and the /README/ directory from the
standard library, and the /Cubical/ directory from the Cubical library
open in my work space so that I can easily click through the source
files. Even if you use Cabal to install Agda, you should download the
source code for your version somewhere, because otherwise you won't have
local copies of the builtins and primitives. The repo also has folders
specified for the Standard and Cubical libraries, so you can place those
files there and to have everything in one location.

## Comparison with Haskell Syntax

Haskell:
```Haskell
-- Data construction (with GADTs syntax and explicit forall)
data Foo a where
  Bar :: forall a. a -> Foo a
  Baz :: forall a. a -> Foo a

-- Pattern matching
unwrap :: forall a. Foo a -> a
unwrap (Bar a) = a
unwrap (Baz a) = a
```

Agda:
```Agda
-- Data is always declared with GADTs syntax
data Foo (A : Set) : Set where
  Bar : A → Foo A
  Baz : A → Foo A

-- We need to pass a type parameter, but Agda lets us do it implicitly
-- by surrounding it with curly braces at the beginning of the
-- type declaration.
unwrap : {A : Set} → Foo A → A
unwrap (Bar a) = a
unwrap (Baz a) = a

-- We can also universally quantify over the input type
wrapDeeper : ∀ {A} → Foo A → Foo (Foo A)
wrapDeeper (Bar a) = Bar (Bar a)
wrapDeeper (Baz a) = Baz (Baz a)

-- If we want to pass the type explicitly, we can
id : (A : Set) → A → A 
id τ a = a

-- If we want to, we can set up variables to stand for arbitrary types
-- at the start of our file 
private
  variable
    A : Set
    B : Set

-- And then we can use them freely in type declarations, which makes
-- definitions look similar to Haskell with implicit forall
fooMap : (A → B) → Foo A → Foo B
fooMap f (Bar a) = Bar (f a)
fooMap f (Baz a) = Baz (f a)
```

## Comparison between Agda and Haskell Types



### Haskell

Haskell's type system has three main entities: terms, types, and kinds.

Terms are the data constructors inside of algebraic data types, as well
as functions. Types are, well, the types. They are collections of values,
containing a (possibly empty) set of data constructors which tell us
how to construct a term of that type. Kinds are the type of types. Kinds
are denoted with ```*``` in Haskell, although right now we are in a
transition period of changing that to ```Type```. Right now, the actual
name is ```Type```, but by default GHC has a pragma on that renames it
```*``` for backwards compatibility reasons.

Basic types, such as ```Int``` and ```Bool``` have kind ```*```, which
is the basic kind of types. But we can also have functions from types to
types, using type constructors, which have function kinds, such as
```* -> *``` or ```* -> (* -> * -> *)```. These are
the kinds of functions from types to types. ```Either``` is a higher
order type constructor with kind ```* -> * -> *```, that is, it takes
a type of kind ```*```, another type of kind ```*```, and returns a
type of kind ```*```. Haskell allows you to query the type or kind of an 
expression in GHCi by using :t and :k respectively. When using fancy types,
:k! will normalize the kind, which amounts to normalizing the type level 
computation, whereas :k by itself might not show the result of applications.

```Constraint``` is also a kind (different from ```*```, but I won't go into 
typeclasses too deeply because Agda doesn't have them (they use records and 
first class type level functions instead). 

Haskell is not a fully first order implementation of the lambda cube. While
polymorphism is first class (with Rank N Types and Impredicative Types), we 
don't have real type level lambdas. However, there are various ways to write a 
lot of type level functions, namely Functional Dependencies and Type Families.
The Data Kinds extension takes all data constructors in scope and
creates new kinds with their names. This is very useful for type level
computation with Type Families. Haskell does not have dependent types,
but they are on their way. Ultimately what this means is that you cannot
write a function that returns a type based on term level values, yet.

Haskell also has "unified" types and kinds. What this means is that kinds
are in a very literal sense, the "types of types", and, importantly,
this means that ```* :: *```, and even ```(* -> *) -> * :: *```. This
simplifies a lot of the systems, but it makes the core language logically
inconsistent. 

Relatedly, Haskell is not a total language. It does not have a termination
checker, and a lot of the "nice" category theoretic properties about the
type system aren't really true in practice because every type is inhabited
by a polymorphic constructor called ```undefined``` (and also ```error```),
which represents nontermination. As a result, ```Void```, or the empty type,
is actually inhabited and not an initial object in the category of Haskell
types and functions.

The lack of totality combined with the logical inconsistencies of
```* :: *``` mean that Haskell is not a proof assistant, which is fine,
because those decisions allow for a much more robust language with which 
to write code. The current plans for adding dependent types are not to
change Haskell into a proof assistant in this way, but maybe some sort of
system will be worked out in the end so that we can have both.

When Haskell finally gets dependent types, however, kinds will likely be
removed, as everything they serve to do can now be done with types and
terms in a first class way. In this vein, Agda doesn't really have kinds,
only terms, types and types that have types as values.

### Agda

Agda, on the other hand, is a version of Martin-Lof type theory, which means
it is an intensional dependently typed programming language with first class
types. Agda's type system is called its "sort" system, and it uses objects
called universes. There are terms in Agda, which are the data constructors
of types. Types also have types, and any type which has a type as a value
is called a universe. The basic sort in Agda is ```Set``` (although this
upsets type theory people and they rename it to Type a lot of the time). Any
type, like ``Bool`` or ```Int``` has type ```Set```, and a higher order
type constructor like ```Either``` has type ```Set -> Set -> Set```. 

```Set``` itself, however, does not have type ```Set```, as that would be
inconsistent. In Agda ```Set : Set₁```, and indeed ```(Set -> Set -> Set) : Set₁```. 
Type constructors of a type ```Setₙ``` for some n, or type constructors that
are functions of values that are at most of type ```Setₙ``` have type ```Setₙ₊₁```.

What's incredible about languages like Agda, and what make them so much fun
to mess around with when you come from something like Haskell, is that
functions involving types are first class. All of these are legal Agda
declarations:

```Agda
data Either (A : Set) (B : Set) : Set where
  left  : (a : A) → Either A B 
  right : (b : B) → Either A B 

eitherPartial : (A : Set) → (Set → Set)
eitherPartial a = Either a 

Bar : Set₁
Bar = Set → Set

eitherPartial' : (A : Set) → Bar
eitherPartial' = eitherPartial

Baz : Set₁ → Set₁
Baz a = Set → (Set → Set) → Set → a

Boz : Set₂
Boz = Set₁ → Set₁

Buz : Boz
Buz = Baz 
```
```Either``` is a higher order type constructor which takes two types of type 
```Set```  and returns a type of type ```Set```. 

eitherPartial is a type level function that takes a type of type ```Set``` and returns
```Either``` partially applied to it. You could do this in Haskell with type as
```type Partial a = Either a```. But here, we're writing an actual function
 in a first class way. Note that the return type in the Agda function is a 
 function from types to types.

```Bar``` is a name for *the type* of a type level function which takes one type
to another type.

```eitherPartial'``` is the same as ```eitherPartial``` except that we're using
```Bar``` as the name for the return type, to show that it's a first class value.

And finally, ```Baz``` shows how we can use higher levels of universes as first
class types as well. ```Boz``` and ```Buz``` are just there to reenforce the
idea that all of this is really first class. ```Boz``` is the type of ```Baz```,
and ```Buz``` is ```Baz``` but written with ```Boz``` as its type.

Two last things to note. First, the subscripts refer to universe levels, and
in order to have functions (i.e. type constructors) that are "universe polymorphic"
you need to involve level constructors. Secondly, this kind of level arithmetic
causes problems because it means we can universally quantify over all finite levels.

As an answer, we have another sort, disjoint from ```Setₙ```s, called
```Setω``` which induces another infinite hierarchy of ```Setω+n```s. 
This hierarchy, however, cannot be quantified over, and so we don't need
to induce another infinite hierarchy.

## Dependent Types

Sigma types are the disjoint union of an index set and a dependent type. That is,
it's the collection of all pairs (x : A, B(x)). 

```Agda
open import Data.Product
open import Data.Nat

data Vect (A : Set) : ℕ → Set where
  []   : Vect A zero
  _::_ : {n : ℕ} → A → Vect A n → Vect A (suc n)
infixr 5 _::_

VectOfℕ : ℕ → Set
VectOfℕ = Vect ℕ

myVectOf3 : Σ ℕ VectOfℕ
myVectOf3 = ( 3 , 1 :: 2 :: 3 :: [])

myVectOf3' : Σ ℕ VectOfℕ
myVectOf3' = ( 3 , 1 :: 2 :: 3 :: [])

myVectOf2 : Σ ℕ VectOfℕ
myVectOf2 = ( 2 , 2 :: 3 :: [])

myVectOf2' : Σ ℕ VectOfℕ
myVectOf2' = ( 2 , 420 :: 3 :: []) 
```

Anything of type ```Σ ℕ VectOfℕ``` is going to be a pair where the first element is a 
number n and the second is a vector of length n. All lists of that length, not just 
one, work with that index. The ```Σ``` syntax is internally a record and it expects 
the second type to be a dependent function type that takes an element of the first 
type as an argument. If we had used ```Vect ℕ``` as the type, we would have needed
to put it in parentheses for parsing. Regular products are the special case of Σ 
types where the second type doesn't actually depend on the first. If you want to use
```Σ``` notation for those types, you need to wrap the second type with a lambda
that throws away its argument, e.g. ```(λ _ → B)```.

## Connection between Agda and MLTT

In terms of going from MLTT to Agda, we take Pi takes for granded but phrases them in
the (x : A) -> B way. Inductive types are defined in terms of their former, introduction, 
and elimination rules, while the computation rules are, I guess, just part of the ambient beta 
reduction of Agda? Agda actually handles the elimination rules itself as well, using 
pattern matching, but we can write it ourselves if we want to. So in Agda, an 
inductive type looks like 

```Agda
data Bool : Set where -- Type former
  tt : Bool           -- Introduction
  ff : Bool           -- |

Bool-elim : (A : Bool -> Set) -> A tt -> A ff -> (x : Bool) -> A x -- Elimination
Bool-elim A a1 a2 tt = a1                                          -- |
Bool-elim A a1 a2 ff = a2                                          -- |
```

The type former is given by the signature in the data declaration. The introduction is given by the
data constructors. Internally, Agda then lets you pattern match in the Haskell/ML way on them for
elimination, but we can define elimination as a function itself which takes in the options for output
depending on the constructor and returns the right one. Honestly, this still looks like pattern matching
to me and I'm not sure how it would be written without two clauses.

[See here](https://wiki.portal.chalmers.se/agda/Libraries/Martin-L%f6fTypeTheory?from=Libraries.MLTT) and especially the book by 
[Nordström, Petersson, and Smith](http://www.cse.chalmers.se/research/group/logic/book/book.pdf).
