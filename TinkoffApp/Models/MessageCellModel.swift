//
//  MessageCellModel.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
struct MessageCellModel {
    let message: String
}
struct Message {
//    let message: String
//    let type: MessageType
//    enum MessageType {
//        case input
//        case output
//    }
    let messageId: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
}

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
