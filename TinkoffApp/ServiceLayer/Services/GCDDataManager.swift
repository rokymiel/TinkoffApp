//
//  GCDDataManager.swift
//  TinkoffApp
//
//  Created by Михаил on 13.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import  UIKit

class GCDDataManager: DataSaverProtocol {
    private var dataManager: DataManagerProtocol
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    public func write(name: String?, description: String?, image: UIImage?) {
        dataManager.hasErrors = false
        DispatchQueue.global().async {
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global().async {
                if let userName = name {
                    self.dataManager.write(data: userName, filePath: DataManager.usernamePath)
                    
                }
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                if let userDescription = description {
                    self.dataManager.write(data: userDescription, filePath: DataManager.userDesriptionPath)
                }
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                if let data = image?.pngData() {
                    self.dataManager.writeImage(data: data)
                } else {
                    self.dataManager.delete(fileName: DataManager.imagePath)
                }
                group.leave()
            }
            group.wait()
            self.dataManager.completionBlock?(self.dataManager.hasErrors)
            
        }
    }
    public func read(_ action: @escaping (String, String, UIImage?) -> Void) {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            var username: String?
            var userDescription: String?
            var image: UIImage?
            group.enter()
            DispatchQueue.global().async {
                username = self.dataManager.read(path: DataManager.usernamePath)
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                
                userDescription = self.dataManager.read(path: DataManager.userDesriptionPath)
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                
                image = self.dataManager.readImage()
                group.leave()
            }
            group.wait()
            DispatchQueue.main.async {
                action(username ?? "", userDescription ?? "", image)
            }
        }
    }
    
}
