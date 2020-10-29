//
//  CoreDataStackAsync.swift
//  TinkoffApp
//
//  Created by Михаил on 29.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData

class  CoreDataStackAsync {
    
    let queue = DispatchQueue(label: "corequeue")
    init() {
        queue.async {
            guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("document has not found")
            }
            self.storeURL = documentsURL.appendingPathComponent("Chat.sqlite")
            guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
                fatalError("model not found")
            }
            guard let managedObject = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("managedObjectModel cound not ve created")
            }
            self.managedObjectModel = managedObject
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObject)
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
            } catch {
                fatalError(error.localizedDescription)
            }
            self.persistentStoreCoordinator = coordinator
            let wContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            wContext.persistentStoreCoordinator = coordinator
            wContext.mergePolicy = NSOverwriteMergePolicy
            self.writterContext = wContext
            let mContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            mContext.parent = wContext
            mContext.automaticallyMergesChangesFromParent = true
            mContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            self.mainContext = mContext
        }
        
    }
    
    private var storeURL: URL?
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) var managedObjectModel: NSManagedObjectModel?
    
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    private var writterContext: NSManagedObjectContext?
    
    private(set) var mainContext: NSManagedObjectContext?
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        queue.async {
            let context = self.saveContext()
            context.performAndWait {
                block(context)
                if context.hasChanges {
                    self.performSave(in: context)
                }
            }
            
        }
        
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        if context == writterContext {
            context.perform {
                do {
                    try context.save()
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        } else {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
            if let parent = context.parent { self.performSave(in: parent) }
            
        }
        
    }
    func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector:
            #selector(managedObjectContextObjectsDidChange),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    @objc
    private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        printSaved()
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            NSLog("Добавлено объектов: \(inserts.count)")
        }
        if let update = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, update.count > 0 {
            NSLog("Обновлено объектов: \(update.count)")
        }
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            NSLog("Удалено объектов: \(deletes.count)")
        }
        
    }
    
    private func printSaved(_ message: String = "") {
        mainContext?.perform {
            do {
                let channels = try self.mainContext?.fetch( Channel_db.fetchRequest()) as? [Channel_db] ?? []
                let messages = try self.mainContext?.fetch( Message_db.fetchRequest()) as? [Message_db] ?? []
                NSLog("\(message)Число сохраненных каналов: \(channels.count), Число сохраненных сообщений: \(messages.count)")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    func printSavedData(with message: String) {
        queue.async {
            self.printSaved(message)
        }
    }
}
