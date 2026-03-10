// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorKit",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
    products: [
        .library(name: "ColorKit", targets: ["ColorKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kieranb662/Sliders.git" , from: "2.0.1"),
    ],
    targets: [
        .target(name: "ColorKit", dependencies: ["Sliders"]),
    ]
)
