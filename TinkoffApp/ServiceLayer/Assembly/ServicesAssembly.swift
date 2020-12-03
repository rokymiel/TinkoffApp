//
//  ServicesAssembly.swift
//  TinkoffApp
//
//  Created by Михаил on 11.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var userID: UserIDProtocol { get }
    var theme: ThemeManagerProtocol { get }
    var coreData: CoreDataManagerProtocol { get }
    var net: NetManagerProtocol { get }
}

class ServicesAssembly: IServicesAssembly {
    lazy var theme: ThemeManagerProtocol = ThemeManager(RootAssembly.coreAssembly.themeSaver)
    lazy var userID: UserIDProtocol = UserIDManager(RootAssembly.coreAssembly.userIDSaver)
    lazy var coreData: CoreDataManagerProtocol = CoreDataManager(dataStack: RootAssembly.coreAssembly.dataStack)
    lazy var net: NetManagerProtocol = NetManager(requestSender: RootAssembly.coreAssembly.requestSender)
}
