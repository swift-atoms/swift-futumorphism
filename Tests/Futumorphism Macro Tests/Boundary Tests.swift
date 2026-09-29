import Corecursive_Macro
import Free_Macro
import Functor_Base_Macro
import Futumorphism_Macro
import Testing

@Corecursive
@Free
@FunctorBase
@Futumorphism
private indirect enum Count {
    case zero
    case successor(Count)
}

private func depth(_ value: Count) -> Int {
    switch value {
    case .zero: 0
    case let .successor(child): depth(child) + 1
    }
}

@Suite
struct `Futumorphism boundaries` {
    @Test
    func `a seed that stops at once unfolds to the base case`() {
        let value = Count.futumorphism(0) { _ -> Count.Base<Count.Free<Int>> in .zero }
        #expect(depth(value) == 0)
    }

    @Test
    func `plain seeds unfold one layer at a time`() {
        let value = Count.futumorphism(5) { seed -> Count.Base<Count.Free<Int>> in
            seed == 0 ? .zero : .successor(.pure(seed - 1))
        }
        #expect(depth(value) == 5)
    }
}
