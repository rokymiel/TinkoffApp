//
//  ObjectsExtensions.swift
//  TinkoffApp
//
//  Created by Михаил on 28.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

extension Message_db {
    convenience init(message: MessageCellModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        senderName = message.senderName
        senderId = message.senderId
        created = message.created
        content = message.content
        messageId = message.messageId
        channelID = message.channelID
    }
}

extension Channel_db {
    convenience init(channel: ConversationCellModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        identifier = channel.identifier
        name = channel.name
        lastMessage = channel.lastMessage
        lastActivity = channel.lastActivity
    }
}