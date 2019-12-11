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
    
    private let urlSession: URLSession
    
    // Since we have no guarantee the publishers will be kept in memory by anyone else, we keep a refrence
    private var requestPublishers: [Cancellable] = []
    
    init(urlSession: URLSession = .shared){
        self.urlSession = urlSession
    }
    
    enum ApiError: Error {
        case couldNotConvertData(message: String)
    }
    
    @discardableResult
    func getCodable<T: Codable>(from url: URL, completionHandler: @escaping (_: Result<T, Error>)->()) -> Cancellable {
        let codaleRequestPublisher = self.urlSession.dataTaskPublisher(for: url)
            .map {
                print("Got data!", $0)
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
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
        self.requestPublishers.append(codaleRequestPublisher)
        return codaleRequestPublisher
    }
    
    @discardableResult
    func getImage(from url: URL, completionHandler: @escaping (_: Result<UIImage, Error>)->()) -> Cancellable {
        let imageRequestPublisher = self.urlSession.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: RunLoop.main)
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
                    return
                }
                completionHandler(.success(image))
            })
        self.requestPublishers.append(imageRequestPublisher)
        return imageRequestPublisher
    }
}
