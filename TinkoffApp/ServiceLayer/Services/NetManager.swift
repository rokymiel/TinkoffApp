//
//  NetManager.swift
//  TinkoffApp
//
//  Created by Михаил on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

protocol NetManagerProtocol {
    func loadImageList(completionHandler: @escaping (ResponseModel?, String?) -> Void)
}

class NetManager: NetManagerProtocol {
    let requestSender: IRequestSender

    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    func loadImageList(completionHandler: @escaping (ResponseModel?, String?) -> Void) {
        let requestConfig = RequestsFactory.ImageListRequest.newImageListConfig()
        
        requestSender.send(requestConfig: requestConfig) { (result: Result<ResponseModel, NetworkError>) in
            
            switch result {
            case .success(let apps):
                completionHandler(apps, nil)
            case .failure(let error):
                completionHandler(nil, error.message)
            }
        }
    }
}
