//
//  ConversationViewCell.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ConversationViewCell: UITableViewCell,ConfigurableView {
    typealias ConfigurableType = ConversationCellModel
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    func applyTheme(){
        backgroundColor = ThemeManager.currentTheme().mainColor
        messageLabel.textColor = ThemeManager.currentTheme().textColor
        userNameLabel.textColor = ThemeManager.currentTheme().textColor
    }
    func configure(with model: ConfigurableType) {
        userNameLabel.text=model.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if Calendar.current.compare(model.date, to: Date(), toGranularity: .day).rawValue==0{
            formatter.dateFormat = "HH:mm"
        }else{
            formatter.dateFormat="dd MMM"
        }
        
        if model.hasUnreadMessages{
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)]
            messageLabel.attributedText = NSMutableAttributedString(string:model.message, attributes:attrs)

        } else{
            messageLabel.font = UIFont(name: "System", size: messageLabel.font.pointSize)
            messageLabel.text=model.message
        }
        
        timeLabel.text=formatter.string(from: model.date)
        if model.isOnline&&model.message.isEmpty{
            messageLabel.font=UIFont(name: "AppleSDGothicNeo-Thin", size: messageLabel.font.pointSize)
            messageLabel.text="No messages yet"
        }
        
        if model.isOnline {
            onlineLabel.isHidden=false
        }
        else{
            onlineLabel.isHidden = true
        }
    }

    
}