// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let VERSION_PARAM_KIT: PackageDescription.Version = "5.0.0"
let VERSION_ANALYTICS_KIT: PackageDescription.Version = "3.0.0"
let VERSION_CRASH_REPORTER: PackageDescription.Version = "2.1.0"
let VERSION_NETWORK_REACHABILITY: PackageDescription.Version = "2.0.1"
let VERSION_COMMON_UI: PackageDescription.Version = "1.1.0"
let package = Package(

    name: "PayUIndia-NativeOtpAssist",
    platforms: [.iOS(.v11)],

    products: [
        .library(
            name: "PayUIndia-NativeOtpAssist",
            targets: ["PayUIndia-NativeOtpAssistTarget"]
        )
    ],

    dependencies: [
        .package(name: "PayUIndia-PayUParams", url: "https://github.com/payu-intrepos/payu-params-iOS", from: VERSION_PARAM_KIT),
        .package(name: "PayUIndia-NetworkReachability", url: "https://github.com/payu-intrepos/PayUNetworkReachability-iOS", from: VERSION_NETWORK_REACHABILITY),
        .package(name: "PayUIndia-Analytics", url: "https://github.com/payu-intrepos/PayUAnalytics-iOS", from: VERSION_ANALYTICS_KIT),
        .package(name: "PayUIndia-CrashReporter", url: "https://github.com/payu-intrepos/PayUCrashReporter-iOS", from: VERSION_CRASH_REPORTER),
        .package(name: "PayUIndia-CommonUI", url: "https://github.com/payu-intrepos/PayUCommonUI-iOS", from: VERSION_COMMON_UI)
    ],

    targets: [
        .binaryTarget(name: "PayUNativeOtpAssist", path: "./framework/PayUNativeOtpAssist.xcframework"),
        .target(
            name: "PayUIndia-NativeOtpAssistTarget",
            dependencies: [
                .product(name: "PayUIndia-PayUParams", package: "PayUIndia-PayUParams"),
                "PayUIndia-Analytics",
                "PayUIndia-NetworkReachability",
                "PayUIndia-CrashReporter",
                "PayUNativeOtpAssist"
            ],
            path: "PayUIndia-NativeOtpAssistWrapper"
        )
    ]

)
