// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "AndroidUIKit",
    dependencies: [
        //.Package(url: "https://github.com/PureSwift/Android.git", majorVersion: 0)
        .package(url: "git@github.com:PureSwift/Android.git", .branch("master"))
    ],
    targets: [
        .target(name: "AndroidUIKit",
            dependencies: ["Android"],
            path: "Sources")
        ]
)
