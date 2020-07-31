// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QR",
    platforms: [
        .macOS("10.15"),
        .iOS("13.0"),
    ],
    products: [
        .library(name: "QR", targets: ["QR"])
    ],
    dependencies: [],
    targets: [
        .target(name: "QR")
    ]
)

#if os(macOS)

let helper = Target.target(name: "QRHelper", dependencies: [
    "QR",

    .product(name: "ArgumentParser", package: "swift-argument-parser"),
])

package.targets += [helper]
package.products += [.executable(name: "qr", targets: ["QRHelper"])]
package.dependencies += [
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.0.4")),
]
#endif
