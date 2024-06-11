// swift-tools-version:5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GetStream",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "GetStream", targets: ["GetStream"]),
        .library(name: "Faye", targets: ["Faye"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .exactItem("14.0.1")),
        .package(url: "https://github.com/daltoniam/Starscream.git", .exactItem("4.0.6")),
        .package(url: "https://github.com/camelan/Swime", .exactItem("3.1.1")),
    ],
    targets: [
        .target(name: "GetStream", dependencies: ["Moya", "Faye", .product(name: "Swime", package: "Swime")], path: "Sources", exclude: ["Token"]),
        .target(name: "Faye", dependencies: ["Starscream"], path: "Faye"),
        .testTarget(name: "GetStreamTests", dependencies: ["GetStream"], path: "Tests", exclude: ["Token"]),
    ]
)
