//
//  ImageCache.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

class ImageStore {
    
    private let imageCache: NSCache<AnyObject, UIImage>
    
    init(countLimit: Int = 100) {
        self.imageCache = NSCache<AnyObject, UIImage>()
        self.imageCache.countLimit = countLimit
    }
    
    func getImage(for url: URL) -> UIImage? {
        return self.imageCache.object(forKey: url as AnyObject)
    }
    
    func storeImage(_ image: UIImage, for url: URL) {
        self.imageCache.setObject(image, forKey: url as AnyObject)
    }
    
}
