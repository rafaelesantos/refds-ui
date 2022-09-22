// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RefdsUI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RefdsUI",
            targets: ["RefdsUI"]
        ),
        .library(
            name: "RefdsUIDynamic",
            type: .dynamic,
            targets: ["RefdsUI"]
        ),
        .library(
            name: "RefdsUIStatic",
            type: .static,
            targets: ["RefdsUI"]
        )
    ],
    targets: [
        .target(
            name: "RefdsUI",
            resources: [
                .copy("Foundation/Icons/Icons.ttf"),
                .copy("Foundation/Typography/Moderat-Mono-Thin.ttf"),
                .copy("Foundation/Typography/Moderat-Mono-Light.ttf"),
                .copy("Foundation/Typography/Moderat-Mono-Regular.ttf"),
                .copy("Foundation/Typography/Moderat-Mono-Medium.ttf"),
                .copy("Foundation/Typography/Moderat-Mono-Bold.ttf"),
                .copy("Foundation/Typography/Moderat-Mono-Black.ttf")
            ]
        ),
        .testTarget(
            name: "RefdsUITests",
            dependencies: ["RefdsUI"]
        )
    ]
)
