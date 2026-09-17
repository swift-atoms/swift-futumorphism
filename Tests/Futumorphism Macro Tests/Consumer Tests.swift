import Futumorphism_Macro
import Testing

@Futumorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `futumorphism realizes scheduled future layers`() {
    let value = Natural.futumorphism(2) { seed -> Natural.Base<Natural.Free<Int>> in
        switch seed {
        case 0: .zero
        case 2: .successor(.suspend(.successor(.pure(0))))
        default: .successor(.pure(seed - 1))
        }
    }
    guard case .successor(.successor(.zero)) = value else {
        Issue.record("Expected two scheduled successors")
        return
    }
}
