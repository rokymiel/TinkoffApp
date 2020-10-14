//
//  OperationDataManager.swift
//  TinkoffApp
//
//  Created by Михаил on 13.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
class OperationDataManager:DataManager,DataManagerProtocol {
    
    func write(name: String?, description: String?, image: UIImage?, end: @escaping () -> Void) {
        let queue=OperationQueue()
        let operation = DataWriteOperation(name: name, description: description, image: image, dataManager: self)
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                if(!self.hasErrors){
                    end()
                    self.saveDoneAlert?()
                }
            }
        }
        queue.addOperation(operation)
        
    }
    
    func read(_ action: @escaping (String, String, UIImage?) -> Void) {
        let queue=OperationQueue()
        let operation = DataReadOperation(operationManager: self)
        operation.completionBlock = {
            OperationQueue.main.addOperation{
                action(operation.username ?? "",operation.userDescription ?? "",operation.image)}
        }
        queue.addOperation(operation)
    }
    
    
}

class DataReadOperation:Operation{
    public weak var manager:OperationDataManager?
    public init(operationManager:OperationDataManager){
        manager=operationManager
    }
    public var username:String?
    public var userDescription:String?
    public var image:UIImage?
    override func main() {
        
        username = manager?.read(path:DataManager.usernamePath)
        userDescription = manager?.read(path: DataManager.userDesriptionPath)
        image = manager?.readImage()
        
        
    }
}
class DataWriteOperation:Operation {
    public var username:String?
    public var userDescription:String?
    public var profileImage:UIImage?
    public weak var manager:OperationDataManager?
    
    public init(name:String?,description:String?,image:UIImage?, dataManager:OperationDataManager) {
        username = name
        userDescription = description
        profileImage=image
        manager=dataManager
        manager?.hasErrors=false
        
    }
    override func main() {
        if let name = username{
            manager?.write(data: name, filePath:OperationDataManager.usernamePath)
            
        }
        if let description = userDescription{
            manager?.write(data: description, filePath: OperationDataManager.userDesriptionPath)
        }
        if let data = profileImage?.pngData(){
            manager?.writeImage(data: data)
        } else{
            manager?.delete(fileName: DataManager.imagePath)
        }
        
        
    }
}
