//
//  MessageCellModel.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
protocol MessageCellModel {
    var messageId: String { get }
    var content: String { get }
    var created: Date { get }
    var senderId: String { get }
    var senderName: String { get }
    var channelID: String { get }
}
struct Message: MessageCellModel {
    let messageId: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    let channelID: String
    
}
