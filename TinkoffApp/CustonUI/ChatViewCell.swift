//
//  ChatViewCell.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ChatViewCell: UITableViewCell,ConfigurableView {
    typealias ConfigurableType =
    MessageCellModel

    func configure(with model: MessageCellModel) {
        inputMessageView.layer.cornerRadius = 15
        outputMessageView.layer.cornerRadius = 15
        switch messageType {
        case .input:
            inputMessageView.isHidden=false
            outputMessageView.isHidden=true
            inputMessageLabel.text=model.message
        case .output:
            inputMessageView.isHidden=true
            outputMessageView.isHidden=false
            outputMessageLabel.text=model.message
        default: break
            
        }
        setColors()
        setNeedsLayout()
    }
    func setColors() {
        inputMessageLabel.textColor = ThemeManager.currentTheme().textColor
        outputMessageLabel.textColor = ThemeManager.currentTheme().textColor
        inputMessageView.backgroundColor = ThemeManager.currentTheme().inputMessageColor
        outputMessageView.backgroundColor = ThemeManager.currentTheme().outputMessageColor
        backgroundColor=ThemeManager.currentTheme().mainColor
    }
    public var messageType:Message.MessageType!
    @IBOutlet weak var inputMessageLabel: UILabel!
    @IBOutlet weak var outputMessageLabel: UILabel!
    @IBOutlet weak var inputMessageView: UIView!
    @IBOutlet weak var outputMessageView: UIView!
    
}
