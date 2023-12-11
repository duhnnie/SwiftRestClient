// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRestClient",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_15),
        .watchOS(.v4),
        .tvOS(.v11),
        .macCatalyst(.v13)
    ],
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
    ],
    swiftLanguageVersions: [.v5]
)
