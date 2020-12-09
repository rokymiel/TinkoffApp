//
//  RequestFactory.swift
//  TinkoffApp
//
//  Created by Михаил on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
struct RequestsFactory {
    
    struct ImageListRequest {
        static var apiKey = Bundle.main.object(forInfoDictionaryKey: "Images_Token") as? String ?? ""
        static func newImageListConfig() -> RequestConfig<CodableParser> {
            return RequestConfig<CodableParser>(request: ImagesRequest(apiKey: apiKey), parser: CodableParser())
        }
    }
    
}
