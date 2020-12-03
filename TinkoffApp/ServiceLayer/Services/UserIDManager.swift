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
    //func loadId()
}
class UserIDManager: UserIDProtocol {
    public var userId: String
    private var userIDSaver: UserIDSaverProtocol
    init(_ userIDSaver: UserIDSaverProtocol) {
        userId = ""
        self.userIDSaver = userIDSaver
        self.loadId()
    }
    public func loadId() {
        let id = userIDSaver.readId()
        if id.isEmpty {
            let identifier = UUID()
            userId = identifier.uuidString
            userIDSaver.write(id: userId)
        } else {
            userId = id
        }
    }
}
