// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Atomizer AR",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "Atomizer AR",
            targets: ["AppModule"],
            bundleIdentifier: "com.johnseong.atomizer",
            teamIdentifier: "Z64KRUX3W3",
            displayVersion: "1.1",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
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
            capabilities: [
                .camera(purposeString: "For our augmented reality features, we need permission to use your device's camera."),
                .outgoingNetworkConnections(),
                .incomingNetworkConnections()
            ],
            appCategory: .education
        )
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", "7.0.0"..<"8.0.0"),
        .package(url: "https://github.com/magicien/GLTFSceneKit", "0.4.1"..<"1.0.0"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", "2.0.0"..<"3.0.0"),
        .package(url: "https://github.com/exyte/ActivityIndicatorView.git", "1.0.0"..<"2.0.0"),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", "0.6.1"..<"1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", "5.0.0"..<"6.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "Kingfisher", package: "kingfisher"),
                .product(name: "GLTFSceneKit", package: "gltfscenekit"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                .product(name: "ActivityIndicatorView", package: "activityindicatorview"),
                .product(name: "Introspect", package: "swiftui-introspect"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
                .product(name: "Alamofire", package: "alamofire")
            ],
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)