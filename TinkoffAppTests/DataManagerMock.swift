//
//  DataManagerMock.swift
//  TinkoffAppTests
//
//  Created by Михаил on 03.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//
@testable import TinkoffApp
import UIKit
class DataManagerMock: DataManagerProtocol {
    private var imageData: Data?
    private var stringData = ["1": "2"]
    var completionBlock: Completion?
    var hasErrors: Bool = false
    
    var checkDirectoryCallsCount = 0
    var writeImageCallsCount = 0
    var readImageCallsCount = 0
    var deleteCallsCount = 0
    var writeCallsCount = 0
    var readCallsCount = 0
    
    init(_ block: Completion? ) {
        completionBlock = block
    }
    
    func checkDirectory(_ path: String) -> String? {
        checkDirectoryCallsCount += 1
        return path
    }
    
    func writeImage(data: Data) {
        writeImageCallsCount += 1
        mutexImage.lock()
        imageData = data
        mutexImage.unlock()
    }
    
    func readImage() -> UIImage? {
        readImageCallsCount += 1
        if let image = imageData {
            return UIImage(data: image)
        }
        return nil
        
    }
    
    func delete(fileName: String) {
        deleteCallsCount += 1
        stringData.removeValue(forKey: fileName)
    }
    private let mutexStringData = NSLock()
    private let mutexImage = NSLock()
    func write(data: String, filePath: String) {
        writeCallsCount += 1
        mutexStringData.lock()
        stringData[filePath] = data
        mutexStringData.unlock()
    }
    
    func read(path: String) -> String {
        readCallsCount += 1
        return stringData[path] ?? "None"
    }
    
}
