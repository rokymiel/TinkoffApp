//
//  ChatViewCell.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ChatViewCell: UITableViewCell,ConfigurableView {
    typealias ConfigurableType = MessageCellModel
    func configure(with model: MessageCellModel) {
        switch messageType {
        case .input:
            inputMessageLabel.isHidden=false
            outputMessageLabel.isHidden=true
            inputMessageLabel.text=model.message
        case .output:
            inputMessageLabel.isHidden=true
            outputMessageLabel.isHidden=false
            outputMessageLabel.text=model.message
        default: break
            
        }
        setNeedsLayout()
    }
    public var messageType:Message.MessageType!
    @IBOutlet weak var inputMessageLabel: UILabel!
    @IBOutlet weak var outputMessageLabel: UILabel!
    
}
