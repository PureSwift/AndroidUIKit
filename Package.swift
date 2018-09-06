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
