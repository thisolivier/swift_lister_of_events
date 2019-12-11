//
//  EventStore.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

class EventStore {
    
    let events: [Event] = []
    
    func indexForUrl(_ url: URL) -> Int? {
        // Assumed that each event has a unique image
        return events.firstIndex(where: { (event: Event) in
            return event.image == url
        })
    }
    
    func indexForId(_ id: String) -> Int? {
        return events.firstIndex(where: { (event: Event) in
            return event.id == id
        })
    }
    
}
