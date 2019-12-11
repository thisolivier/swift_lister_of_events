//
//  EventsListViewInteractor.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

class EventsListViewInteractor: EventsListViewInteractorable {
    
    var countOfEvents: Int = 0
    
    func loadNext() {
        print("Loading next")
    }
    
    func setFavoriteState(onRow row: Int, favoriteState: FavouriteState) {
        print("Setting favourite state")
    }
    
    func getEventAtRow(_ row: Int) {
        print("getting event at row")
    }
    
}
