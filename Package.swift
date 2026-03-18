// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SwiftTUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftTUI",
            targets: ["SwiftTUI"]),
        .library(
            name: "SwiftTUIiOS",
            targets: ["SwiftTUIiOS"]),
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftTUI",
            dependencies: []),
        .target(
            name: "SwiftTUIiOS",
            dependencies: ["SwiftTUI"]),
        .testTarget(
            name: "SwiftTUITests",
            dependencies: ["SwiftTUI"]),
    ]
)
