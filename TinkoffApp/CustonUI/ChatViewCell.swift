//
//  ChatViewCell.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ChatViewCell: UITableViewCell, ConfigurableView {
    typealias ConfigurableType = Message
    var userID: String!
    func configure(with model: Message) {
        inputMessageView.layer.cornerRadius = 20
        outputMessageView.layer.cornerRadius = 20
        if userID == model.senderId {
            senderNameLabel.isHidden = true
            inputMessageView.isHidden = true
            inputUsername.isHidden = true
            outputMessageView.isHidden = false
            outputMessageLabel.text = model.content
        } else {
            senderNameLabel.text = model.senderName
            senderNameLabel.isHidden = false
            inputMessageView.isHidden = false
            inputUsername.isHidden = false
            outputMessageView.isHidden = true
            inputMessageLabel.text = model.content
        }
        setColors()
        setNeedsLayout()
    }
    func setColors() {
        inputUsername.textColor = ThemeManager.currentTheme().textColor
        inputMessageLabel.textColor = ThemeManager.currentTheme().textColor
        outputMessageLabel.textColor = ThemeManager.currentTheme().textColor
        inputMessageView.backgroundColor = ThemeManager.currentTheme().inputMessageColor
        outputMessageView.backgroundColor = ThemeManager.currentTheme().outputMessageColor
        backgroundColor = ThemeManager.currentTheme().mainColor
    }
    
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var inputMessageLabel: UILabel!
    @IBOutlet weak var outputMessageLabel: UILabel!
    @IBOutlet weak var inputMessageView: UIView!
    @IBOutlet weak var outputMessageView: UIView!
    @IBOutlet weak var inputUsername: UILabel!
    
}
