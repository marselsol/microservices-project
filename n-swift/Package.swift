// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "n-swift",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            path: "./Sources/App"
        )
    ]
)