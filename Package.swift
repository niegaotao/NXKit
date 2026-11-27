// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "NXKit",
    platforms: [.iOS(.v15)],
    products: [.library(name: "NXKit", targets: ["NXKit"])],
    targets: [
        .target(
            name: "NXKit",
            path: "NXKit",
            exclude: ["Assets/.gitkeep", "Classes/.gitkeep"],
            sources: ["Classes"],
            resources: [.copy("Assets/NXKit.bundle")]
        )
    ]
)
