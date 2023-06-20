# The Book in Lean

This project aims to state and verify the proofs from [Proofs from THE BOOK](https://link.springer.com/book/10.1007/978-3-662-57265-8) by Martin Aigner and Günter M. Ziegler. The book presents different short proofs of a variety of results from six different areas. The results and proofs are stated in [Lean](https://leanprover.github.io), in particular in version 3.51.1.

## Number theory

### The infinity of primes

See `data.nat.prime`for `prime` property and formulation of `theorem exists_infinite_primes`.

#### Euclid's Proof ✅

Done. This is the proof implemented in mathlib for `theorem exists_infinite_primes`.
It's also in "Mathematics in Lean" in the chapter on number theory.

#### Second Proof ✅

Done.

#### Third Proof ❌
Open. Requires group theory (Lagrange).

#### Fourth Proof ❌
Open. Requires logarithms and finite sums and products.

#### Fifth Proof ❌
Open.

#### Sixth proof ❌
Open. Requires square roots, floor function, and finite sums.


### Bertrand's postulate

### Binomial coefficients are (almost) never power

### Representing numbers as sums of two squares

### Every finite division ring is a field

### Some irrational number

### Three times π²/6

## Analysis

## Geometry

## Combinatorics

### Pigeon-hole and double counting

A variets of pigeonhole principles are implemented in mathlib, see the [documentation](https://leanprover-community.github.io/mathlib_docs/combinatorics/pigeonhole.html).

### Three famous theorems on finite sets

### Shuffling cards

### Lattice paths and determinants

### Cayley's formula for the number of trees

### Completing Latin squares

### The Dinitz problem

### Identities versus bijections



## Graph Theory
