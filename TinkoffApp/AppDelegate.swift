//
//  AppDelegate.swift
//  TinkoffApp
//
//  Created by Михаил on 15.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func applicationDidFinishLaunching(_ application: UIApplication) {
        Logger.logFunctionName(from: "not running", to: "inactive")
    }
    //3
    func applicationWillResignActive(_ application: UIApplication) {
         Logger.logFunctionName(from: "active", to: "inactive")
    }
    //2
    func applicationDidBecomeActive(_ application: UIApplication) {
         Logger.logFunctionName(from: "inactive", to: "active")
    }
    //5
    func applicationDidEnterBackground(_ application: UIApplication) {
         Logger.logFunctionName(from: "inactive", to: "background")
    }
    //4
    func applicationWillEnterForeground(_ application: UIApplication) {
       Logger.logFunctionName(from: "background", to: "inactive")
    }
    func applicationWillTerminate(_ application: UIApplication) {
         Logger.logFunctionName(from: getState(application.applicationState), to: "terminated")
    }
    func getState(_ state:UIApplication.State)->String{
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
//    func logFunctionName(from:String,to:String,functionName: String = #function) {
//        print("Application moved from \(from) to \(to): \(functionName)")
//    }


}

