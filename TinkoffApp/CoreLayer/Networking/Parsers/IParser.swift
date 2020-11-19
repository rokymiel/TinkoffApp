//
//  IParser.swift
//  TinkoffApp
//
//  Created by Михаил on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
