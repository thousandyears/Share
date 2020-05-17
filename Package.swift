// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Share",
    products: [
        .library(name: "Share", targets: ["Share"]),
    ],
    dependencies: [ ],
    targets: [
        .target(name: "Share", dependencies: []),
        .testTarget(name: "ShareTests", dependencies: ["Share"]),
    ]
)
