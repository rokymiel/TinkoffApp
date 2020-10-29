//
//  CoreDataManager.swift
//  TinkoffApp
//
//  Created by Михаил on 28.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private static var coreDataStack: CoreDataStack = {
        let stack = CoreDataStack()
        stack.enableObservers()
        return stack
    }()
    private static var coreAsync: CoreDataStackAsync = {
        let stack = CoreDataStackAsync()
        stack.enableObservers()
        return stack
    }()
    /**
     Сохраняем каналы
     
     - Parameter channels: Каналы, которые необходимо сохранить.
     */
    static func save(channels: [Channel]) {
                coreDataStack.performSave { context in
                    for channel in channels {
                        _ = Channel_db(channel: channel, in: context)
                    }
                }
        
        // MARK: - CoreDataStackAsync сохранение каналов
        
//        coreAsync.performSave { context in
//            for channel in channels {
//                _ = Channel_db(channel: channel, in: context)
//            }
//        }
        
    }
    /**
     Сохраняем сообщения
     
     - Parameter messages: Сообщения, которые необходимо сохранить.
     */
    static func save(messages: [Message]) {
                coreDataStack.performSave { context in
                    for message in messages {
                        _ = Message_db(message: message, in: context)
                    }
                }
        // MARK: - CoreDataStackAsync сохранение сообщений
        
//        coreAsync.performSave { context in
//            for message in messages {
//                _ = Message_db(message: message, in: context)
//            }
//        }
    }
    /// Читает все сообщения и выводит в логи
    static func readAllData() {
        coreDataStack.printSavedData(with: "На устройстве: ")
        
        // MARK: - CoreDataStackAsync чтение сохраненных данных
        
        //coreAsync.printSavedData(with: "На устройстве: ")
    }
    
}
