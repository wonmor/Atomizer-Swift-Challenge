// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Atomizer",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "Atomizer",
            targets: ["AppModule"],
            bundleIdentifier: "1",
            teamIdentifier: "Z64KRUX3W3",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .flower),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            appCategory: .education
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftUIX/SwiftUIX", "0.1.4"..<"1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "SwiftUIX", package: "swiftuix")
            ],
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)