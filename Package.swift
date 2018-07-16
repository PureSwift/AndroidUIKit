// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//let package = Package(
//    name: "AndroidUIKit",
//    targets: [
//        Target(
//            name: "AndroidUIKitDemo",
//            dependencies: [.Target(name: "AndroidUIKit")]),
//        Target(
//            name: "AndroidUIKit"
//        )
//    ],
//    dependencies: [],
//    exclude: ["Demo"]
//)

let package = Package(
    name: "AndroidUIKit",
    products: [
        .library(name: "AndroidUIKit", type: .dynamic, targets: ["AndroidUIKit"]),
        ],
    dependencies: [
        .package(url: "git@github.com:PureSwift/Android.git", .revision("becd2aebfa3f0f3162b3a8cdf646fa3142998d8d"))
    ],
    targets: [
        .target(
            name: "AndroidUIKit",
            dependencies: ["Android"],
            path: "Sources"
        ),
    ]
)
