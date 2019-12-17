// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxMKMapView",
    products: [
        .library(
            name: "RxMKMapView",
            targets: ["RxMKMapView"]),
    ],
    dependencies: [
         .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "RxMKMapView",
            dependencies: ["RxCocoa", "RxSwift"],
            path: "Sources"),
    ]
)
