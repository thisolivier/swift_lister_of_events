//
//  EventStore.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

class EventStore {
    
    private var events: [Event] = [] {
        didSet {
            print("Saving Events - are we main?", Thread.isMainThread)
            print("Events saved! we have:", self.events)
        }
    }
    
    var eventsCount: Int {
        print("Counting Events - are we main?", Thread.isMainThread)
        return events.count
    }
    
    func addEvents(_ events: [Event]) {
        self.events.append(contentsOf: events)
        print("We now have \(eventsCount) events")
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
