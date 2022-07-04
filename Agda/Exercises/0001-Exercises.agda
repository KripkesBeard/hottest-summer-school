{-# OPTIONS --without-K --safe #-}

module 0001-Exercises where

open import prelude hiding (not-is-involution)

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
n ^ zero = 1
n ^ suc m = n * (n ^ m)

^-example : 3 ^ 4 ≡ 81
^-example = refl 81

_! : ℕ → ℕ
zero ! = 1
suc n ! = suc n * (n !)

!-example : 4 ! ≡ 24
!-example = refl 24

