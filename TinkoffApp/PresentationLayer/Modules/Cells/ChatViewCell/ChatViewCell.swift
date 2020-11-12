//
//  ChatViewCell.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ChatViewCell: UITableViewCell, ConfigurableView {
    typealias ConfigurableType = Message_db
    var userID: String!
    func configure(with model: Message_db) {
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
        inputUsername.textColor = RootAssembly.serviceAssembly.theme.currentTheme().textColor
        inputMessageLabel.textColor = RootAssembly.serviceAssembly.theme.currentTheme().textColor
        outputMessageLabel.textColor = RootAssembly.serviceAssembly.theme.currentTheme().textColor
        inputMessageView.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().inputMessageColor
        outputMessageView.backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().outputMessageColor
        backgroundColor = RootAssembly.serviceAssembly.theme.currentTheme().mainColor
    }
    
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var inputMessageLabel: UILabel!
    @IBOutlet weak var outputMessageLabel: UILabel!
    @IBOutlet weak var inputMessageView: UIView!
    @IBOutlet weak var outputMessageView: UIView!
    @IBOutlet weak var inputUsername: UILabel!
    
}
