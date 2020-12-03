//
//  RequestSenderMock.swift
//  TinkoffAppTests
//
//  Created by Михаил on 02.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//
@testable import TinkoffApp
import Foundation

class RequestSenderMock: IRequestSender {
    var callsCount = 0
    var url: URL?
    var failure = false
    var failurMessage = "testError"
    init(fail: Bool) {
        failure = fail
    }
    
    var model: ResponseModel = .init(hits: [.init(id: 123, webformatURL: "test1.ru"), .init(id: 123, webformatURL: "test2.ru")])
    func send<Parser>(requestConfig config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model, NetworkError>) -> Void) where Parser: IParser {
        callsCount += 1
        url = config.request.urlRequest?.url
        if failure {
            completionHandler(.failure(.error(message: failurMessage)))
        } else {
            if let model = model as? Parser.Model {
                completionHandler(.success(model))
            } else {
                completionHandler(.failure(.error(message: "cast error")))
            }
            
        }
        
    }
    
}
