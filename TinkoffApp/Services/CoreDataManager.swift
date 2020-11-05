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
    
    static var coreDataStack: CoreDataStack = {
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
            var channelsDB = [Channel_db]()
            for channel in channels {
                
                channelsDB.append(Channel_db(channel: channel, in: context))
            }
            do {
                try context.obtainPermanentIDs(for: channelsDB)
            } catch {
                
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
            var messagesDB = [Message_db]()
            for message in messages {
                messagesDB.append(Message_db(message: message, in: context))
            }
            do {
                try context.obtainPermanentIDs(for: messagesDB)
            } catch {
                
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
    static func deleteChannel(with id: String) {
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", id)
        request.predicate = predicate
        if let channel = coreDataStack.fetch(request: request) {
            coreDataStack.delete(object: channel)
        }
        let mRequest: NSFetchRequest<Message_db> = Message_db.fetchRequest()
        let mPredicate = NSPredicate(format: "channelID == %@", id)
        mRequest.predicate = mPredicate
        if let messages = coreDataStack.fetchMany(request: mRequest) {
            for message in messages {
                coreDataStack.delete(object: message)
            }
        }
        
    }
    static func deleteChannel(_ channel: Channel_db) {
        deleteChannel(with: channel.identifier!)
    }
    static func
        getFetchedResultsController(fetchRequest: NSFetchRequest<NSFetchRequestResult>)-> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchRequest
        
    }
//    static func contains(with id: String) -> Bool{
//        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
//        let predicate = NSPredicate(format: "identifier == %@", id)
//        request.predicate = predicate
//        return coreDataStack.fetchManyOnMain(request: request)?.count ?? 0 > 0
//    }
    static func updateChannel(_ channel: Channel) {
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", channel.identifier)
        request.predicate = predicate
        let request2: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        request2.predicate = predicate
        if let cc = coreDataStack.fetch(request: request), let c2 = coreDataStack.fetchOnMain(request: request2) {
            cc.setValue(channel.lastActivity, forKey: "lastActivity")
            cc.setValue(channel.lastMessage, forKey: "lastMessage")
            c2.setValue(channel.lastActivity, forKey: "lastActivity")
            c2.setValue(channel.lastMessage, forKey: "lastMessage")
            
        }
    }
    
}
