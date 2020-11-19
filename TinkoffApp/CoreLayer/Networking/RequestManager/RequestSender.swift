//
//  RequestSender.swift
//  TinkoffApp
//
//  Created by Михаил on 17.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

protocol IRequestSender {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completionHandler: @escaping(Result<Parser.Model, NetworkError>) -> Void)
}
enum NetworkError: Error {
    case error(message: String)
    var message: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}
class RequestSender: IRequestSender {
    
    var session: URLSession
    init(with session: URLSession) {
        self.session = session
    }
    func send<Parser>(requestConfig config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, NetworkError>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(.error(message: "url string can't be parsed to URL")))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completionHandler(.failure(.error(message: error.localizedDescription)))
                return
            }
            guard let data = data,
                let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completionHandler(.failure(.error(message: "received data can't be parsed")))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}
