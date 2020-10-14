//
//  GCDDataManager.swift
//  TinkoffApp
//
//  Created by Михаил on 13.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import  UIKit
class GCDDataManager:DataManager,DataManagerProtocol {
    public func write(name:String?,description:String?,image:UIImage?, end: @escaping()->Void){
        hasErrors=false
        DispatchQueue.global().async {
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global().async {
                if let userName=name{
                    self.write(data: userName, filePath: DataManager.usernamePath)
                    
                }
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                if let userDescription = description{
                    self.write(data: userDescription, filePath: DataManager.userDesriptionPath)
                }
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                if let data = image?.pngData(){
                    self.writeImage(data: data)
                }else{
                    self.delete(fileName: DataManager.imagePath)
                }
                group.leave()
            }
            group.wait()
            DispatchQueue.main.async {
                if(!self.hasErrors){
                    end()
                    self.saveDoneAlert?()
                    
                }
            }
        }
    }
    public func writeTheme(theme:Theme,fileName:String){
        DispatchQueue.global().async {
            self.write(data: String(theme.rawValue), filePath: fileName)
        }
    }
    public func readTheme(fileName:String)->Theme{
        return Theme(rawValue: Int(read(path: fileName)) ?? 0) ?? .classic
    }
    public func read(_ action: @escaping (String,String,UIImage?)->Void){
        DispatchQueue.global().async {
            let group = DispatchGroup()
            var username:String?
            var userDescription:String?
            var image:UIImage?
            group.enter()
            DispatchQueue.global().async {
                username = self.read(path:DataManager.usernamePath)
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                
                userDescription = self.read(path: DataManager.userDesriptionPath)
                group.leave()
            }
            group.enter()
            DispatchQueue.global().async {
                
                image = self.readImage()
                group.leave()
            }
            group.wait()
            DispatchQueue.main.async {
                action(username ?? "",userDescription ?? "",image)
            }
        }
    }
    
    
    
    
}
