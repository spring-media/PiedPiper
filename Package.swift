// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "PiedPiper",
  platforms: [
    .iOS(.v10),
    .macOS(.v10_12),
    .tvOS(.v10),
    .watchOS(.v3)
  ],
  products: [
    .library(
      name: "PiedPiper",
      targets: ["PiedPiper"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.1"))
  ],
  targets: [
    .target(
      name: "PiedPiper",
      path: "Sources"
    ),
    .testTarget(
      name: "PiedPiperTests",
      dependencies: [
        "PiedPiper",
        "Quick",
        "Nimble"
      ],
      path: "Tests"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
