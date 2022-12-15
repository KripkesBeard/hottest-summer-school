{-# OPTIONS --without-K --safe #-}

module 0001-Exercises where

open import prelude hiding (not-is-involution)

⊥ : Set
⊥ = 𝟘

⊤ : Set
⊤ = 𝟙



{- Part I: Writing functions on Booleans, natural numbers and lists -}


{- Exercise 1 
-- In the lectures we defined `&&` (logical and) on `Bool` by pattern matching on
-- the leftmost argument only.
--
-- Define the same operation but this time by pattern matching (case splitting)
-- on both arguments.
-}

_&&'_ : Bool → Bool → Bool
true  &&' true  = true
true  &&' false = false
false &&' true  = false
false &&' false = false

{- Exercise 2
-- Define `xor` (excluse or) on `Bool`. Exclusive or is true if and only if
-- exactly one of its arguments is true.
-}

_xor_ : Bool → Bool → Bool
true  xor true  = false
true  xor false = true
false xor true  = true
false xor false = false

{- Exercise 3
-- Define the exponential and factorial functions on natural numbers.
--
-- If you do things correctly, then the examples should compute correctly, i.e. the
-- proof that 3 ^ 4 ≡ 81 should simply be given by `refl _` which says that the
-- left hand side and the right hand side compute to the same value.
-}

_^_ : ℕ → ℕ → ℕ
n ^ zero  = 1
n ^ suc m = n * (n ^ m)

^-example : 3 ^ 4 ≡ 81
^-example = refl 81

_! : ℕ → ℕ
zero  ! = 1
suc n ! = suc n * (n !)

!-example : 4 ! ≡ 24
!-example = refl 24

{- Exercise 4
-- Define the minimum of two natural numbers recursively
-}

min : ℕ → ℕ → ℕ
min zero    _       = zero
min (suc n) zero    = zero
min (suc n) (suc m) = suc (min n m)

min-example : min 5 3 ≡ 3
min-example = refl 3

{- Exercise 5
-- Use pattern matching on lists to define map.
-}

map : {X Y : Type} → (X → Y) → List X → List Y
map f []        = []
map f (x :: xs) = f x :: (map f xs)

map-example : map (_+ 3) (1 :: 2 :: 3 :: []) ≡ 4 :: 5 :: 6 :: []
map-example = refl _

{- Exercise 6
-- Define filter.
-}

filter : {X : Type} (p : X → Bool) → List X → List X
filter p [] = []
filter p (x :: xs) = if p x then x :: (filter p xs) else filter p xs

is-non-zero : ℕ → Bool
is-non-zero zero    = false
is-non-zero (suc _) = true

filter-example : filter is-non-zero (4 :: 3 :: 0 :: 1 :: 0 :: []) ≡ 4 :: 3 :: 1 :: []
filter-example = refl _ 



{- Part II: The identity type of the Booleans -}


{- Exercise 1
-- Define ≣ for Booleans.
-}

_≣_ : Bool → Bool → Type
true  ≣ true  = ⊤
true  ≣ false = ⊥
false ≣ true  = ⊥
false ≣ false = ⊤

{- Exercise 2 
-- Show that for every Boolean b we can find an element of the type b ≣ b.
-}

Bool-refl : (b : Bool) → b ≣ b
Bool-refl true  = ⋆
Bool-refl false = ⋆

{- Exercise 3
-- Show that we can go back and forth between a ≣ b and a ≡ b.
-}

-- We didn't go over this in class so I'll come back and figure it out later
≡-to-≣ : (a b : Bool) → a ≡ b → a ≣ b
≡-to-≣ = {!   !}

≣-to-≡ : (a b : Bool) → a ≣ b → a ≡ b
≣-to-≡ = {!   !}



{- Part III: Proving in Agda -}


{- Exercise 1
-- Use pattern matching to prove that || is commutative.
-}

||-is-commutative : (a b : Bool) → a || b ≡ b || a
||-is-commutative true  true  = refl true
||-is-commutative true  false = refl true
||-is-commutative false true  = refl true
||-is-commutative false false = refl false

{- Exercise 2 
-- State and prove that `&&` is commutative.
-}

&&-is-commutative : (a b : Bool) → a && b ≡ b && a
&&-is-commutative true  true  = refl true
&&-is-commutative true  false = refl false
&&-is-commutative false true  = refl false
&&-is-commutative false false = refl false

{- Exercise 3
-- Prove that && and &&' are both associative.
-}

&&-is-associative : (a b c : Bool) → a && (b && c) ≡ (a && b) && c
&&-is-associative true  b c = refl (b && c)
&&-is-associative false b c = refl false

&&'-is-associative : (a b c : Bool) → a &&' (b &&' c) ≡ (a &&' b) &&' c
&&'-is-associative true  true  true  = refl true
&&'-is-associative true  true  false = refl false
&&'-is-associative true  false true  = refl false
&&'-is-associative true  false false = refl false
&&'-is-associative false true  true  = refl false
&&'-is-associative false true  false = refl false
&&'-is-associative false false true  = refl false
&&'-is-associative false false false = refl false

{- Question: Can you spot a downside of the more verbose definition of &&' now? -}
-- Sure, it causes reflection proofs to be longer. On the other hand, it's more
-- efficient because it doesn't have a (non-tail-) recursive call to the operator/constructor.

{- Exercise 4
-- Prove that min is commutative.
-}

min-is-commutative : (n m : ℕ) → min n m ≡ min m n
min-is-commutative zero zero = refl zero
min-is-commutative zero (suc m) = refl zero
min-is-commutative (suc n) zero = refl zero
min-is-commutative (suc n) (suc m) = {!  !}

{- Exercise 5
-- Show that n ≡ n + 0 for every natural number n.
-}

0-right-neutral : (n : ℕ) → n ≡ n + 0
0-right-neutral = {!!}

{- Exercise 6
-- Prove the functor laws for map.
-}

map-id : {X : Type} (xs : List X) → map id xs ≡ xs
map-id xs = {!!}

map-comp : {X Y Z : Type} (f : X → Y) (g : Y → Z) (xs : List X) → map (g ∘ f) xs ≡ map g (map f xs)
map-comp f g xs = {!!}
