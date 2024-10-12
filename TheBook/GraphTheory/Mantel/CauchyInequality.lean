import TheBook.ToMathlib.EdgeFinset
import TheBook.ToMathlib.WeightedDoubleCounting
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Combinatorics.SimpleGraph.DegreeSum
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Aesop

set_option trace.aesop true
set_option autoImplicit false

prefix:100 "#" => Finset.card
set_option linter.unusedSectionVars false

namespace CauchyMantelTheorem

variable {α : Type*} [Fintype α] [DecidableEq α]
variable {G : SimpleGraph α} [DecidableRel G.Adj]

local notation "V" => @Finset.univ α _
local notation "E" => G.edgeFinset
local notation "N(" v ")" => G.neighborFinset v
local notation "I(" v ")" => G.incidenceFinset v
local notation "d(" v ")" => G.degree v
local notation "χ(" p ")" => if p then 1 else 0
local notation "n" => Fintype.card α

-- Mantel's Theorem
theorem mantel (h: G.CliqueFree 3) : #E ≤ (n^2 / 4) := by

  -- The degrees of two adjacent vertices cannot sum to more than n
  have adj_degree_bnd (i j : α) (hij: G.Adj i j) : d(i) + d(j) ≤ n := by
    -- Assume the contrary ...
    by_contra hc; simp at hc

    -- ... then by pigeonhole there would exist a vertex k adjacent to both i and j ...
    obtain ⟨k, h⟩ := Finset.inter_nonempty_of_card_lt_card_add_card (by simp) (by simp) hc
    simp at h
    obtain ⟨hik, hjk⟩ := h

    -- ... but then i, j, k would form a triangle, contradicting that G is triangle-free
    exact h {k, j, i} ⟨by aesop (add safe G.adj_symm), by simp [hij.ne', hik.ne', hjk.ne']⟩

  -- We need to define the sum of the degrees of the vertices of an edge ...
  let sum_deg (e : Sym2 α) : ℕ := Sym2.lift ⟨λ x y ↦ d(x) + d(y), by simp [Nat.add_comm]⟩ e

  -- ... and establish a variant of adj_degree_bnd ...
  have adj_degree_bnd' (e : Sym2 α) (he: e ∈ E) : sum_deg e ≤ n := by
    induction e with | _ v w => simp at he; exact adj_degree_bnd v w (by simp [he])

  -- ... as well as ...
  have sum_deg_eq (e : Sym2 α) (he: e ∈ E) : sum_deg e = ∑ v ∈ e, d(v) := by
    induction e with | _ v w => simp at he; simp [sum_deg, he.ne]

  -- ... and finally
  have sum_sum_deg_eq_sum_deg_sq : ∑ e ∈ E, sum_deg e = ∑ v ∈ V, d(v)^2 := by
    calc  ∑ e ∈ E, sum_deg e
      _ = ∑ e ∈ E, ∑ v ∈ e, d(v)                  := Finset.sum_congr rfl sum_deg_eq
      _ = ∑ e ∈ E, ∑ v ∈ {v' | v' ∈ e}, d(v)      := by simp [Sym2.toFinset_eq]
      _ = ∑ v ∈ V, ∑ e ∈ {e' ∈ E | v ∈ e'}, d(v)  := Finset.sum_sum_bipartiteAbove_eq_sum_sum_bipartiteBelow _ E V (λ _ v ↦ d(v))
      _ = ∑ v ∈ V, ∑ e ∈ I(v), d(v)               := Finset.sum_congr rfl (λ v ↦ by simp [G.incidenceFinset_eq_filter v])
      _ = ∑ v ∈ V, d(v)^2                         := by simp [Nat.pow_two]

  -- We slightly modify the main argument to avoid division by a potentially zero n ...
  have := calc #E * n^2
    _ = (n * (∑ e ∈ E, 1)) * n               := by simp [Nat.pow_two, Nat.mul_assoc, Nat.mul_comm]
    _ = (∑ e ∈ E, n) * n                     := by rw [Finset.mul_sum]; simp
    _ ≥ (∑ e ∈ E, sum_deg e) * n             := Nat.mul_le_mul_right n (Finset.sum_le_sum adj_degree_bnd')
    _ = (∑ v ∈ V, d(v)^2) * (∑ v ∈ V, 1^2)   := by simp [sum_sum_deg_eq_sum_deg_sq]
    _ ≥ (∑ v ∈ V, d(v) * 1)^2                := (Finset.sum_mul_sq_le_sq_mul_sq V (λ v ↦ d(v)) 1)
    _ = (2 * #E)^2                           := by simp [G.sum_degrees_eq_twice_card_edges]
    _ = 4 * #E^2                             := by ring

  -- ... and now show #E ≤ n^2 / 4 by "simply" dividing by 4 * #E
  by_cases hE : #E = 0
  · aesop
  · push_neg at hE
    sorry

end CauchyMantelTheorem
