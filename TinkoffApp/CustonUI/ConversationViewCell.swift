//
//  ConversationViewCell.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationViewCell: UITableViewCell, ConfigurableView {
    typealias ConfigurableType = Channel_db
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    func applyTheme() {
        backgroundColor = ThemeManager.currentTheme().mainColor
        messageLabel.textColor = ThemeManager.currentTheme().textColor
        userNameLabel.textColor = ThemeManager.currentTheme().textColor
    }
    func configure(with model: ConfigurableType) {
        userNameLabel.text = model.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.isHidden = true
        if let date = model.lastActivity {
            if Calendar.current.compare(date, to: Date(), toGranularity: .day).rawValue == 0 {
                formatter.dateFormat = "HH:mm"
            } else {
                formatter.dateFormat="dd MMM"
            }
            timeLabel.isHidden = false
            timeLabel.text = formatter.string(from: date)
        }
        if let lastMessage = model.lastMessage, !lastMessage.isEmpty {
            messageLabel.text = lastMessage
        } else {
            messageLabel.text = "No messages yet"
        }
    }
    
}
