// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "RxMKMapView",
            targets: ["RxMKMapView"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift",
            .exact("5.0.1")
        )
    ],
    targets: [
        .target(
            name: "RxMKMapView",
            dependencies: ["RxSwift", "RxCocoa"],
            path: "Sources",
            exclude: [])
    ]
)
