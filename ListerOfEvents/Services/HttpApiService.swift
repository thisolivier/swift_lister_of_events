//
//  File.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Combine
import UIKit

class HttpApiService {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared){
        self.urlSession = urlSession
    }
    
    enum ApiError: Error {
        case couldNotConvertData(message: String)
    }
    
    @discardableResult
    func getCodable<T: Codable>(from url: URL, completionHandler: (_: Result<T, Error>)->()) -> Cancellable {
        return self.urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }, receiveValue: { value in
                completionHandler(.success(value))
            })
    }
    
    @discardableResult
    func getImage(from url: URL, completionHandler: (_: Result<UIImage, Error>)->()) -> Cancellable {
        return self.urlSession.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }, receiveValue: { (image: UIImage?) in
                guard let image = image else {
                    completionHandler(.failure(ApiError.couldNotConvertData(message: "UIImage could not be initialised")))
                }
                completionHandler(.success(image))
            })
    }
}
