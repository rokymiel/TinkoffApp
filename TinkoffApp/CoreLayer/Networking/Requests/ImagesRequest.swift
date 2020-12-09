//
//  Request.swift
//  TinkoffApp
//
//  Created by Михаил on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class ImagesRequest: IRequest {
    private var key: String
    init(apiKey: String) {
        key = apiKey
    }
    private let baseURL = Bundle.main.object(forInfoDictionaryKey: "Images_URL") as? String ?? ""
    private let imageType = "photo"
    private let perPage = "200"
    private let searchTerm = "yellow+flowers"
    private var getParameters: [String: String] {
        return ["key": key,
                "q": searchTerm,
                "per_page": perPage,
                "image_type": imageType]
    }
    private var urlString: String {
        let getParams = getParameters.compactMap({ "\($0.key)=\($0.value)"}).joined(separator: "&")
        return baseURL + "?" + getParams
    }
    
    // MARK: - IRequest
    var urlRequest: URLRequest? {
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        return nil
    }
    
}
