//
//  ConversationCellModel.swift
//  TinkoffApp
//
//  Created by Михаил on 29.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
protocol ConversationCellModel {
    var identifier: String { get }
    var name: String { get }
    var lastMessage: String? { get }
    var lastActivity: Date? { get }
}
struct Channel: ConversationCellModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
