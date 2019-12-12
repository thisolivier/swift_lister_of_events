//
//  Event.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

struct Event: Codable, Equatable {
    
    let id: String
    let title: String
    let image: URL
    let startDate: Date
    
}

extension Event {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        
        // Decoding image url
        let imageString = try values.decode(String.self, forKey: .image)
        guard let imageUrl: URL = URL(string: imageString) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.image, in: values, debugDescription: "Image url could not be initialised from string response")
        }
        self.image = imageUrl
        
        // Decoding start date
        let timestamp: Double = try values.decode(Double.self, forKey: .startDate)
        self.startDate = Date(timeIntervalSince1970: timestamp)
    }
}
