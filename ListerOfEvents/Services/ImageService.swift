//
//  ImageService.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

class ImageService{
    
    private let httpApiService: HttpApiService
    private let imageStore: ImageStore
    
    init(httpApiService: HttpApiService, imageStore: ImageStore) {
        self.httpApiService = httpApiService
        self.imageStore = imageStore
    }
    
    func getFromCache(by url: URL) -> UIImage? {
        return self.imageStore.getImage(for: url)
    }
    
    func downloadImage(at url: URL, completionHandler: @escaping (_: Bool)->()) {
        self.httpApiService.getImage(from: url, completionHandler: { [weak self] (result: Result<UIImage, HttpApiService.ApiError>) in
            switch result {
            case .success(let image):
                self?.imageStore.storeImage(image, for: url)
                completionHandler(true)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        })
    }
    
}
