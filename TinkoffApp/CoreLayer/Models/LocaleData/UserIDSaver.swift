//
//  UserIDSaver.swift
//  TinkoffApp
//
//  Created by Михаил on 12.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol UserIDSaverProtocol {
    func readId() -> String
    func write(id: String)
}

class UserIDSaver: DataManager, UserIDSaverProtocol {
    public func write(id: String) {
        DispatchQueue.global().async {
            self.write(data: id, filePath: DataManager.userIDPath)
        }
    }
    func readId() -> String {
        return read(path: DataManager.userIDPath)
    }
}
