//
//  ThemeManager.swift
//  TinkoffApp
//
//  Created by Михаил on 07.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//
import UIKit
import Foundation
protocol ThemeManagerProtocol {
    func apply(theme: Theme)
    func currentTheme() -> Theme
}
class ThemeManager: ThemeManagerProtocol {
    private var themeSaver: ThemeSaverProtocol
    init(_ themeSaver: ThemeSaverProtocol) {
        self.themeSaver = themeSaver
    }
    
    // MARK: GCD write and read methods
    func apply(theme: Theme) {
        themeSaver.writeTheme(theme: theme, fileName: ThemeManager.selectedThemeKey + ".txt")
        current = theme
        
    }
    private func setTheme() {
        current = themeSaver.readTheme(fileName: ThemeManager.selectedThemeKey + ".txt")
    }
    
    // Мне здесь польше нравится через UserDefaults так как сохранение выбранное темы это не что-то тяжелое
    // Следовательно здесь можно и синхронно выполнять, так как это сильно не повлияет
    
    // MARK: UserDefaults methods
    //    static func apply(theme:Theme){
    //        UserDefaults.standard.set(theme.rawValue, forKey: selectedThemeKey)
    //        current = theme
    //
    //    }
    //    private static func setTheme(){
    //        if let storedTheme = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int{
    //            current = Theme(rawValue: storedTheme) ?? .classic
    //        } else {
    //            current = .classic
    //        }
    //    }
    static let selectedThemeKey="SelectedThemeKey"
    private var current: Theme?
    
    func currentTheme() -> Theme {
        if let theme = current {
            return theme
        }
        setTheme()
        return current ?? .classic
    }
    
}
