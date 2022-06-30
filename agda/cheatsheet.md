# Cheat Sheet

A cheat sheet for Agda (relative to VSCode with emacs mode on Windows).

### Commands

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


### Libraries

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

### Comparison with Haskell Syntax

Haskell:
```Haskell
-- Data construction (with GADTs syntax and explicit forall)
data Foo a where
  Bar :: forall a. a -> Foo a
  Baz :: forall a. a -> Foo a

-- Pattern matching
unwrapFoo :: forall a. Foo a -> a
unwrapFoo (Bar a) = a
unwrapFoo (Baz a) = a
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
