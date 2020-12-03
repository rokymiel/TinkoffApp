//
//  CodableParser.swift
//  TinkoffApp
//
//  Created by Михаил on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
struct ResponseModel: Decodable, Equatable {
    static func == (lhs: ResponseModel, rhs: ResponseModel) -> Bool {
        return lhs.hits == rhs.hits
    }
    
    let hits: [Image]
    struct Image: Decodable, Equatable {
        let id: Int
        let webformatURL: String
    }
    enum RootKey: String, CodingKey {
        case hits
    }
    //    enum ItemKey: String, CodingKey {
    //        case id
    //        case webformatURL
    //    }
    //    init(from decoder: Decoder) throws {
    //        let container = try decoder.container(keyedBy: RootKey.self)
    //        let titelsUnkeyContainer = try container.nestedUnkeyedContainer(forKey: .hits)
    //        var images: Image = []
    //        while !titelsUnkeyContainer.isAtEnd {
    //            let imagesContainer = try titelsUnkeyContainer.nestedContainer(keyedBy: ItemKey.self)
    //
    //        }
    //    }
    
}
class CodableParser: IParser {
    func parse(data: Data) -> ResponseModel? {
        do {
            print(data)
            let dataModel = try JSONDecoder().decode(ResponseModel.self, from: data)
            return dataModel
        } catch {
            print("LOOOOSERRRR")
            return nil
        }
    }
    
    typealias Model = ResponseModel
    
}
