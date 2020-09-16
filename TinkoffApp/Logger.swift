//
//  Logger.swift
//  TinkoffApp
//
//  Created by Михаил on 15.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class Logger {
    /**
        - description:Вывод сообщения с информацией о переходе State для application
        - parameters:
                - from: переход из данного состояния
                - to: переход в данное состояние
    */
    static func logFunctionName(from:String,to:String,functionName: String = #function) {
        #if DEBUG
        print("Application moved from \(from) to \(to): \(functionName)")
        #endif
    }
    /**
        - description: Логирование с выводом информационного сообщения
        - parameters:
            - with : сообщение для вывода
            - functionName: имя функции
    */
    static func logFunctionName(with message:String,functionName: String = #function) {
        #if DEBUG
        print(message+" : "+functionName)
        #endif
    }
}
