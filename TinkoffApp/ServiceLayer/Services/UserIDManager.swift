//
//  UserIDManager.swift
//  TinkoffApp
//
//  Created by Михаил on 21.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
protocol UserIDProtocol {
    var userId: String { get }
    func loadId()
}
class UserIDManager: UserIDProtocol {
    public var userId: String
    init() {
        userId = ""
        self.loadId()
    }
    public func loadId() {
        let id = RootAssembly.coreAssembly.userIDSaver.readId()
        if id.isEmpty {
            let identifier = UUID()
            userId = identifier.uuidString
            RootAssembly.coreAssembly.userIDSaver.write(id: userId)
        } else {
            userId = id
        }
    }
}
