//
//  ThemeSaver.swift
//  TinkoffApp
//
//  Created by Михаил on 12.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol ThemeSaverProtocol {
    func writeTheme(theme: Theme, fileName: String)
    func readTheme(fileName: String) -> Theme
    
}

class ThemeSaver: DataManager, ThemeSaverProtocol {
    public func writeTheme(theme: Theme, fileName: String) {
        DispatchQueue.global().async {
            self.write(data: String(theme.rawValue), filePath: fileName)
        }
    }
    public func readTheme(fileName: String) -> Theme {
        return Theme(rawValue: Int(read(path: fileName)) ?? 0) ?? .classic
    }
}
