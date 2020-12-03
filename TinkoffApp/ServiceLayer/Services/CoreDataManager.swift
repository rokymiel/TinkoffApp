//
//  CoreDataManager.swift
//  TinkoffApp
//
//  Created by Михаил on 28.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData
protocol CoreDataManagerProtocol {
    func save(channels: [ConversationCellModel])
    func save(messages: [MessageCellModel])
    func readAllData()
    func deleteChannel(with id: String)
    func deleteChannel(_ channel: Channel_db)
    func getFetchedResultsController<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>)-> NSFetchedResultsController<T>
     func updateChannel(_ channel: ConversationCellModel)
}
class CoreDataManager: CoreDataManagerProtocol {
    
    private var coreDataStack: CoreDataStackProtocol
    //private  var coreAsync: CoreDataStackAsyncProtocol = RootAssembly.coreAssembly.dataStackAsync
    init(dataStack: CoreDataStackProtocol) {
        coreDataStack = dataStack
    }
    /**
     Сохраняем каналы
     
     - Parameter channels: Каналы, которые необходимо сохранить.
     */
     func save(channels: [ConversationCellModel]) {
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
     func save(messages: [MessageCellModel]) {
        
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
     func readAllData() {
        coreDataStack.printSavedData(with: "На устройстве: ")
        // MARK: - CoreDataStackAsync чтение сохраненных данных
        
        //coreAsync.printSavedData(with: "На устройстве: ")
    }
    
    /// Удаление канала по id
    /// - Parameter id: id канала
     func deleteChannel(with id: String) {
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
    
    /// Удаление канала
    /// - Parameter channel: Канал для удаления
     func deleteChannel(_ channel: Channel_db) {
        deleteChannel(with: channel.identifier!)
    }
     func
        getFetchedResultsController<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>)-> NSFetchedResultsController<T> {
        let fetchRequest = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchRequest
        
    }
    
    /// Обновление канала
    /// - Parameter channel: канал для обновления
     func updateChannel(_ channel: ConversationCellModel) {
        let request: NSFetchRequest<Channel_db> = Channel_db.fetchRequest()
        let predicate = NSPredicate(format: "identifier == %@", channel.identifier)
        request.predicate = predicate
        if let channelOnMain = coreDataStack.fetchOnMain(request: request) {
            channelOnMain.setValue(channel.lastActivity, forKey: "lastActivity")
            channelOnMain.setValue(channel.lastMessage, forKey: "lastMessage")
            coreDataStack.performUpdate()
            
        }
    }
    
}
