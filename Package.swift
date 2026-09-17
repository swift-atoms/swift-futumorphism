// swift-tools-version: 6.4
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "swift-futumorphism",
    products: [
        .library(name: "Futumorphism Macro", targets: ["Futumorphism Macro"]),
        .library(name: "Futumorphism Macro Core", targets: ["Futumorphism Macro Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-molecules/swift-corecursive.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-free.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "603.0.2"..<"604.0.0"),
    ],
    targets: [
        .target(name: "Futumorphism Macro Core", dependencies: [
            .product(name: "Corecursive Macro Core", package: "swift-corecursive"),
            .product(name: "Free Macro Core", package: "swift-free"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        ]),
        .macro(name: "Futumorphism Macro Plugin", dependencies: [
            "Futumorphism Macro Core",
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),
        .target(name: "Futumorphism Macro", dependencies: ["Futumorphism Macro Plugin"]),
        .testTarget(
            name: "Futumorphism Macro Tests",
            dependencies: ["Futumorphism Macro"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
