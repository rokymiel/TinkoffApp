//
//  Logger.swift
//  TinkoffApp
//
//  Created by Михаил on 15.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class Logger {
    static func logFunctionName(from:String,to:String,functionName: String = #function) {
        #if DEBUG
        print("Application moved from \(from) to \(to): \(functionName)")
        #endif
    }
    static func logFunctionName(with message:String,functionName: String = #function) {
        #if DEBUG
        print(message+":"+functionName)
        #endif
    }
}
