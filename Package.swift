// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "AndroidUIKit",
    products: [
        .library(name: "AndroidUIKit", targets: ["AndroidUIKit"])
        ],
    dependencies: [
        .package(url: "git@github.com:PureSwift/Android.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "AndroidUIKit",
            dependencies: ["Android"],
            path: "Sources"
        )
    ]
)
