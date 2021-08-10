//
//  AppDelegate.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Shubham Garg on 14/06/21.
//

import UIKit
import PayUNativeOtpAssist
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PayUOtpAssist.start()
        return true
    }
}

