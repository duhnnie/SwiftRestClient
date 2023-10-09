// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRestClient",
    products: [
        .library(
            name: "SwiftRestClient",
            targets: ["SwiftRestClient"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftRestClient",
            dependencies: []),
        .testTarget(
            name: "SwiftRestClientTests",
            dependencies: ["SwiftRestClient"]),
    ]
)
