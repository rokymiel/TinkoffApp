//
//  UserIDSaverMock.swift
//  TinkoffAppTests
//
//  Created by Михаил on 02.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

@testable import TinkoffApp
import Foundation
class UserIDSaverMock: UserIDSaverProtocol {
    var readCallsCount = 0
    var writeCallsCount = 0
    var id: String
    init(id: String) {
        self.id = id
    }
    func readId() -> String {
        readCallsCount += 1
        return id
    }
    
    func write(id: String) {
        writeCallsCount += 1
        self.id = id
    }
    
}
