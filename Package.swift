// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AndroidUIKit",
    targets: [
        Target(name: "AndroidUIKit")
    ],
    dependencies: [
        .Package(url: "https://github.com/PureSwift/Android.git", majorVersion: 0)
    ]
)
