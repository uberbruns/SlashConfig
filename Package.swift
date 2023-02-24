// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "SlashConfig",
  products: [
    .library(
      name: "SlashConfig",
      targets: ["SlashConfig"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "SlashConfig",
      dependencies: []
    ),
    .testTarget(
      name: "SlashConfigTests",
      dependencies: ["SlashConfig"]
    ),
  ]
)
