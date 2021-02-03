import PackageDescription

let package = Package(
    name: "MTSDSDK",
    products: [
        .library(name: "MTSDSDK", targets: ["MTSDSDK"]),
    ],
    targets: [
        .target(name: "MTSDSDK", dependencies: []),
        .testTarget(name: "MTSDSDKTests", dependencies: ["MTSDSDK"]),
    ]
)
