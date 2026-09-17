import Corecursive_Macro_Core
import Free_Macro_Core
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        Corecursive_Macro_Core.Derivation.expansion(of: declaration)
            + Free_Macro_Core.Derivation.carrier(of: declaration)
            + operation(of: declaration)
    }

    public static func operation(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
            \(raw: access)static func futumorphism<Seed>(
                _ seed: Seed,
                _ coalgebra: (Seed) -> Base<Free<Seed>>
            ) -> Self {
                func realize(_ future: Free<Seed>) -> Self {
                    switch future {
                    case let .pure(seed): return futumorphism(seed, coalgebra)
                    case let .suspend(layer): return embed(layer.map(realize))
                    }
                }
                return embed(coalgebra(seed).map(realize))
            }
            """]
    }
}
