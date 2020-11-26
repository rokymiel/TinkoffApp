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
    lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterSize = window!.bounds.size
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "tinkoff")?.cgImage
        emitterCell.scale = 0.03
        emitterCell.lifetime = 30.0
        emitterCell.alphaSpeed = 0.1
        emitterCell.emissionRange = .pi * 2
        emitterCell.birthRate = 2
        emitterCell.velocity = 150
        emitterLayer.emitterCells = [emitterCell]
        return emitterLayer
    }()
    lazy var pressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_ :)))
    }()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // Читаем все сохраненные данные
        RootAssembly.serviceAssembly.coreData.readAllData()
        window?.addGestureRecognizer(pressGesture)
        return true
    }
    @objc func longPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if let window = window {
                emitterLayer.beginTime = CACurrentMediaTime()
                print(recognizer.location(in: window))
                window.layer.addSublayer(emitterLayer)
                
            }
        case .changed:
            if let window = window {
                emitterLayer.emitterPosition = recognizer.location(in: window)
                
            }
        case .ended:
            emitterLayer.removeFromSuperlayer()
        default:
            print("NOT BEGAN")
        }
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
