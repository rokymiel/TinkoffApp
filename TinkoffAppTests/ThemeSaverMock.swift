//
//  ThemeSaverMock.swift
//  TinkoffAppTests
//
//  Created by Михаил on 02.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//
@testable import TinkoffApp
import Foundation
class ThemeSaverMock: ThemeSaverProtocol {
    var readCallsCount = 0
    var writeCallsCount = 0
    var theme: Theme = .classic
    func writeTheme(theme: Theme, fileName: String) {
        writeCallsCount += 1
        self.theme = theme
    }
    
    func readTheme(fileName: String) -> Theme {
        readCallsCount += 1
        return theme
    }
    
}
