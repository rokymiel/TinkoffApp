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
        
        static func newImageListConfig() -> RequestConfig<CodableParser> {
            return RequestConfig<CodableParser>(request: ImagesRequest(apiKey: "19151995-bbfacf4ace45de2b06c3a3dde"), parser: CodableParser())
        }
    }
    
}
