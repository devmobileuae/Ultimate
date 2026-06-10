// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Ultimate",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Ultimate", targets: ["Ultimate"]),
        .library(name: "UltimateGallery", targets: ["UltimateGallery"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JakubMazur/lucide-icons-swift", from: "1.17.0"),
    ],
    targets: [
        .target(
            name: "Ultimate",
            dependencies: [.product(name: "LucideIcons", package: "lucide-icons-swift")],
            resources: [.copy("Resources/Fonts")]
        ),
        .target(name: "UltimateGallery", dependencies: ["Ultimate"]),
    ]
)
