//
//  CoreDataStack.swift
//  TinkoffApp
//
//  Created by Михаил on 28.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import CoreData
protocol CoreDataStackProtocol: CoreDataStackBasedProtocol {
    var mainContext: NSManagedObjectContext { get }
    
}
protocol CoreDataStackBasedProtocol {
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void)
    func performUpdate()
    func printSavedData(with message: String)
    func delete(object: NSManagedObject)
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> T?
    func fetchOnMain<T: NSManagedObject>(request: NSFetchRequest<T>) -> T?
    func fetchMany<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]?
    func fetchManyOnMain<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]?
}
class  CoreDataStack: CoreDataStackProtocol {
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private var storeURL: URL = {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("document has not found")
        }
        return documentsURL.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
            fatalError("model not found")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("managedObjectModel cound not ve created")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Context
    
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.saveContext()
        
        context.performAndWait {
            block(context)
            if context.hasChanges {
                self.performSave(in: context)
            }
        }
        
    }
    func performUpdate() {
        let context = mainContext
        context.performAndWait {
            if context.hasChanges {
                self.performSave(in: context)
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
        mainContext.perform {
            do {
                let channels = try self.mainContext.fetch( Channel_db.fetchRequest()) as? [Channel_db] ?? []
                let messages = try self.mainContext.fetch( Message_db.fetchRequest()) as? [Message_db] ?? []
                NSLog("\(message)Число сохраненных каналов: \(channels.count), Число сохраненных сообщений: \(messages.count)")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    func printSavedData(with message: String) {
        DispatchQueue.global().async {
            self.printSaved(message)
        }
    }
    
    /// Удаляет объект из writerContext
    /// - Parameter object: Объект для удаления
    func delete(object: NSManagedObject) {
        writterContext.delete(object)
        do {
            try writterContext.save()
        } catch {
            NSLog("Ошибка удаления объекта \(object)")
        }
    }
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> T? {
        return fetchMany(request: request)?.first
    }
    func fetchOnMain<T: NSManagedObject>(request: NSFetchRequest<T>) -> T? {
        return fetchManyOnMain(request: request)?.first
        
    }
    func fetchMany<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        
        return try? writterContext.fetch(request)
        
    }
    func fetchManyOnMain<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        
        return try? mainContext.fetch(request)
        
    }
}