//
//  DataManager.swift
//  TinkoffApp
//
//  Created by Михаил on 14.10.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
class DataManager {
    static let fileManager = FileManager.default
    static let userIDPath = "userId.txt"
    static let usernamePath = "ussernam.txt"
    static let userDesriptionPath="description.txt"
    static let imagePath="profileImage.png"
    typealias Alert = () -> Void
    public  var saveDoneAlert: Alert?
    public  var saveErrorAlert: Alert?
    public  func checkDirectory(_ path: String) -> String? {
        do {
            let filesInDirectory = try DataManager.fileManager.contentsOfDirectory(atPath: getDocumentsDirectory().path)
            
            let files = filesInDirectory
            if files.count > 0 {
                if let index = files.firstIndex(of: path) {
                    return files[index]
                } else {
                    return nil
                }
            }
        } catch _ as NSError {
            hasErrors = true
            saveErrorAlert?()
        }
        return nil
    }
    public  func writeImage(data: Data) {
        let filename = getDocumentsDirectory().appendingPathComponent(DataManager.imagePath)
        try? data.write(to: filename)
    }
    public  func readImage() -> UIImage? {
        let imagePAth = (getDocumentsDirectory().path as NSString).appendingPathComponent(DataManager.imagePath)
        
        if DataManager.fileManager.fileExists(atPath: imagePAth) {
            return UIImage(contentsOfFile: imagePAth)
        } else {
            return nil
        }
    }
    
    public func delete(fileName: String) {
        let path = (getDocumentsDirectory().path as NSString).appendingPathComponent(fileName)
        if DataManager.fileManager.fileExists(atPath: path) {
            try? DataManager.fileManager.removeItem(atPath: path)
            
        }
    }
    public  func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    public var hasErrors = false
    public  func write(data: String, filePath: String) {
        if !hasErrors {
            let path = (getDocumentsDirectory().path as NSString).appendingPathComponent(filePath)
            // Записываем в файл
            do {
                try data.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                hasErrors = true
                saveErrorAlert?()
            }
        }
    }
    
    public  func read(path: String) -> String {
        // Читаем
        let directoryWithFiles = checkDirectory(path) ?? "Empty"
        
        let path = (getDocumentsDirectory().path as NSString).appendingPathComponent(directoryWithFiles)
        
        if let contentsOfFile = try? String(contentsOfFile: path) {
            return contentsOfFile
            
        }
        return ""
    }
    
}

public protocol DataManagerProtocol {
    func write(name: String?, description: String?, image: UIImage?, end: @escaping() -> Void)
    
    func read(_ action: @escaping (String, String, UIImage?) -> Void)
    
}
