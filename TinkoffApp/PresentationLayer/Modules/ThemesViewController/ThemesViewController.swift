//
//  ThemesViewController.swift
//  TinkoffApp
//
//  Created by Михаил on 06.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

// При работе с этим экраном Retain cycle может возникнуть,
// если в замыкании происходит обращение к self полям и методам другого объекта.
// При этом может получиться так, что объект к чьим полям мы обращаемся уже не используется
// и должен быть уничтожен, но из-за захвата переменных он удаляется.
// И при этом например в замыкании ссылаются на на поля данного экрана
// и тогда получается кользо замкнулось. Они ссывлаются друг на друга

class ThemesViewController: UIViewController {
    typealias ThemeChangedHandler = () -> Void
    @IBOutlet weak var classicThemeView: UIButton!
    @IBOutlet weak var dayThemeView: UIButton!
    @IBOutlet weak var nightThemeView: UIButton!
    var themeHandler: ThemeChangedHandler?
    weak var themeDelegate: ThemesPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        setViewsLayer()
        switch RootAssembly.serviceAssembly.theme.currentTheme() {
        case .classic:
            classicTheme()
        case .day:
            dayTheme()
        case .night:
            nightTheme()
        }
        
    }
    func setViewsLayer() {
        classicThemeView.layer.cornerRadius = 15
        classicThemeView.layer.borderColor = UIColor.systemBlue.cgColor
        dayThemeView.layer.cornerRadius = 15
        dayThemeView.layer.borderColor = UIColor.systemBlue.cgColor
        nightThemeView.layer.cornerRadius = 15
        nightThemeView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    @IBAction func classicViewClicked(_ sender: Any) {
        classicTheme()
        RootAssembly.serviceAssembly.theme.apply(theme: .classic)
        //themeDelegate?.applyTheme()
        themeHandler?()
    }
    func classicTheme() {
        classicThemeView.layer.borderWidth = 5
        dayThemeView.layer.borderWidth = 0
        nightThemeView.layer.borderWidth = 0
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
    
    @IBAction func dayViewClicked(_ sender: Any) {
        dayTheme()
        RootAssembly.serviceAssembly.theme.apply(theme: .day)
        //themeDelegate?.applyTheme()
        themeHandler?()
    }
    func dayTheme() {
        classicThemeView.layer.borderWidth = 0
        dayThemeView.layer.borderWidth = 5
        nightThemeView.layer.borderWidth = 0
        view.backgroundColor = .lightGray
    }
    @IBAction func nightViewClicked(_ sender: Any) {
        nightTheme()
        RootAssembly.serviceAssembly.theme.apply(theme: .night)
        //themeDelegate?.applyTheme()
        themeHandler?()
    }
    func nightTheme() {
        classicThemeView.layer.borderWidth = 0
        dayThemeView.layer.borderWidth = 0
        nightThemeView.layer.borderWidth = 5
        view.backgroundColor = .black
    }
}
