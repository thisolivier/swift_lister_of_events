//
//  EventStore.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

protocol EventSource {
    
    var eventsCount: Int { get }
    
    func getEvent(at: Int) -> Event?
    
}

class EventStore: EventSource {
    
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
    
    func removeAllEvents() {
        self.events = []
    }
    
}
