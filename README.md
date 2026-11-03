# swift-futumorphism

Use this package to build a value of a recursive enum by unfolding it from a seed when one step of the unfold may produce several layers at once. Attach `@Futumorphism` to an enum that also carries `@FunctorBase` (swift-functor), `@Free` (swift-free) and `@Corecursive` (swift-corecursive), and call the generated `futumorphism(_:_:)` with a seed and a coalgebra that turns one seed into one layer of `Base<Free<Seed>>`. Use swift-anamorphism instead when every step produces exactly one layer, swift-apomorphism when a step may hand back an already finished subtree, and swift-chronomorphism when the unfolded value is only folded again.

## Laws

- A child the coalgebra returns as `.pure(seed)` is unfolded again from `seed` with the same coalgebra.
- A child returned as `.suspend(layer)` becomes that layer in the result, without calling the coalgebra for it; its own children are realized by the same two rules. The tests schedule two successors from one seed this way.
- A seed whose first layer has no children (the base case) yields the base case.
- The unfold is eager and depth-first: every child is realized in full before the value is returned. Nothing is lazy or cached. It terminates exactly when every branch reaches a layer with no children; each realized layer is one nested call, so the call-stack depth grows with the depth of the result.
- The generated `futumorphism` is `public` when the enum is declared `public`, and internal otherwise.
- Attaching `@Futumorphism` to anything other than an enum is a compile-time error.
