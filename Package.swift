// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AndroidUIKit",
    products: [
        .library(name: "AndroidUIKit", type: .dynamic, targets: ["AndroidUIKit"]),
        ],
    dependencies: [
        .package(url: "git@github.com:PureSwift/Android.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "AndroidUIKit",
            dependencies: ["Android"],
            path: "Sources"
        ),
    ]
)
