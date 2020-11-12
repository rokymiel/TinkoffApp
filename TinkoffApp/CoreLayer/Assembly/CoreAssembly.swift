//
//  CoreAssembly.swift
//  TinkoffApp
//
//  Created by Михаил on 12.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var dataStack: CoreDataStackProtocol { get }
    var dataStackAsync: CoreDataStackAsyncProtocol { get }
    var themeSaver: ThemeSaverProtocol { get }
    var userIDSaver: UserIDSaverProtocol { get }
}

class CoreAssembly: ICoreAssembly {
    
    lazy var dataStack: CoreDataStackProtocol = {
        let stack = CoreDataStack()
        stack.enableObservers()
        return stack
    }()
    lazy var dataStackAsync: CoreDataStackAsyncProtocol = {
        let stack = CoreDataStackAsync()
        stack.enableObservers()
        return stack
    }()
    lazy var themeSaver: ThemeSaverProtocol = ThemeSaver(nil)
    lazy var userIDSaver: UserIDSaverProtocol = UserIDSaver(nil)
    
}
