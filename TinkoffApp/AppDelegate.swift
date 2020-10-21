//
//  AppDelegate.swift
//  TinkoffApp
//
//  Created by Михаил on 15.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UserIDManager.loadId()
        return true
    }

    // MARK: Application Lifecycle
    func applicationDidFinishLaunching(_ application: UIApplication) {
        Logger.logFunctionName(from: "not running", to: "inactive")
    }
    func applicationWillResignActive(_ application: UIApplication) {
         Logger.logFunctionName(from: "active", to: "inactive")
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
         Logger.logFunctionName(from: "inactive", to: "active")
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
         Logger.logFunctionName(from: "inactive", to: "background")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
       Logger.logFunctionName(from: "background", to: "inactive")
    }
    func applicationWillTerminate(_ application: UIApplication) {
         Logger.logFunctionName(from: getState(application.applicationState), to: "terminated")
    }
    /// Получение строкового представления состояния приложения
    /// - parameter state: Состояние приложения
    func getState(_ state: UIApplication.State) -> String {
        switch state {
        case .active:
            return "active"
        case .background:
            return "background"
        case .inactive:
            return "background"
        default:
            return "none"
        }
    }

}
