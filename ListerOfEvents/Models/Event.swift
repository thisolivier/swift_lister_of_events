//
//  Event.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    let id: String
    let title: String
    let image: URL
    let startDate: Date //  UNIX Format
    
}
