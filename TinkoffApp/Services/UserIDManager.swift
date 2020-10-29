//
//  UserIDManager.swift
//  TinkoffApp
//
//  Created by Михаил on 21.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
class UserIDManager {
    public static var userId: String!
    
    public static func loadId() {
        let dataManager = GCDDataManager()
        let id = dataManager.read(path: DataManager.userIDPath)
        if id.isEmpty {
            let identifier = UUID()
            userId = identifier.uuidString
            dataManager.write(id: userId)
        } else {
            userId = id
        }
    }
}
