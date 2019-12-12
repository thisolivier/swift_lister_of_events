//
//  EventStore.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

class EventStore {
    
    private var events: [Event] = []
    
    var eventsCount: Int {
        return events.count
    }
    
    func addEvents(_ events: [Event]) {
        self.events.append(contentsOf: events)
    }
    
    func getEvent(at index: Int) -> Event? {
        if index < events.count {
            return events[index]
        } else {
            return nil
        }
    }
    
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
