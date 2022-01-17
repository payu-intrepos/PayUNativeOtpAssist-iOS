// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PayUIndia-NativeOtpAssist",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PayUIndia-NativeOtpAssist",
            targets: ["PayUIndia-NativeOtpAssistTarget"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "PayUIndia-PayUParams",url: "https://github.com/payu-intrepos/payu-params-iOS", from: "3.1.0"),
        .package(name: "PayUIndia-NetworkReachability",url: "https://github.com/payu-intrepos/PayUNetworkReachability-iOS", from: "2.0.0"),
        .package(name: "PayUIndia-Analytics",url: "https://github.com/payu-intrepos/PayUAnalytics-iOS", from: "2.0.0"),
        .package(name: "PayUIndia-CrashReporter",url: "https://github.com/payu-intrepos/PayUCrashReporter-iOS", from: "2.0.0")
        
        
    ],
    targets: [
            .binaryTarget(name: "PayUIndia-NativeOtpAssist", path: "./framework/PayUNativeOtpAssist.xcframework"),
                .target(
                    name: "PayUIndia-NativeOtpAssistTarget",
                    dependencies: [
                        .target(name: "PayUIndia-NativeOtpAssist", condition: .when(platforms: [.iOS])),
                        .product(name: "PayUIndia-PayUParams", package: "PayUIndia-PayUParams"),
                        "PayUIndia-Analytics",
                        "PayUIndia-NetworkReachability",
                        "PayUIndia-CrashReporter"
                    ],
                    path: "PayUIndia-NativeOtpAssistWrapper"
                ),
        ]
)
