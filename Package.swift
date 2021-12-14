// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XCTestExtensions",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "XCTestExtensions",
            targets: ["XCTestExtensions"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "XCTestExtensions",
            dependencies: [],
            path: "XCTestExtensions"
        ),
        .testTarget(
            name: "XCTestExtensionsTests",
            dependencies: ["XCTestExtensions"],
            path: "XCTestExtensionsTests"
        ),
    ]
)
