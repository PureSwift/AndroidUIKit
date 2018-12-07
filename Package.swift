// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "AndroidUIKit",
    products: [
        .library(name: "AndroidUIKit", targets: ["AndroidUIKit"])
        ],
    dependencies: [
        .package(url: "https://github.com/PureSwift/Android.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "AndroidUIKit",
            dependencies: ["Android"],
            path: "Sources"
        )
    ]
)
