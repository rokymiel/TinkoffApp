//
//  ThemeManager.swift
//  TinkoffApp
//
//  Created by Михаил on 07.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//
import UIKit
import Foundation
class ThemeManager{
    static func apply(theme:Theme){
        UserDefaults.standard.set(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
        current = theme
        
    }
    static let selectedThemeKey="SelectedThemeKey"
    private static var current:Theme? = nil
    private static func setTheme(){
        if let storedTheme = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int{
            current = Theme(rawValue: storedTheme) ?? .classic
        } else {
            current = .classic
        }
    }
    static func currentTheme() -> Theme {
        if let theme = current {
            return theme
        }
        setTheme()
        return current ?? .classic
    }
    
    
}

enum Theme:Int {
    case classic
    case day
    case night
    var mainColor: UIColor {
        switch self {
        case .classic,.day:
            return .white
        case .night:
            return .black
        }
    }
    var textColor:UIColor{
        switch self {
        case .classic,.day:
            return.black
        case .night:
            return.white
        }
    }
    var inputMessageColor:UIColor{
        switch self {
        case .classic:
            return #colorLiteral(red: 0.8744331002, green: 0.8745589852, blue: 0.8744053245, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.916821897, green: 0.9216682315, blue: 0.930151999, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.1803726256, green: 0.1804046035, blue: 0.180365622, alpha: 1)
            
        }
    }
    var outputMessageColor:UIColor{
        switch self {
        case .classic:
            return #colorLiteral(red: 0.8630293012, green: 0.9701395631, blue: 0.7740517259, alpha: 1)
        case .day:
            return #colorLiteral(red: 0.2641913593, green: 0.5391736031, blue: 0.9753755927, alpha: 1)
        case .night:
            return #colorLiteral(red: 0.3607498407, green: 0.3608062863, blue: 0.3607374728, alpha: 1)
        }
    }
    
}