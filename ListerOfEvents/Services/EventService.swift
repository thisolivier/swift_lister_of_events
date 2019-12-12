//
//  EventService.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

class EventService {
    
    enum EventResult {
        case failure(Error), gotEvents, gotFinalEvent, noInternet
    }
    
    private let httpApiService: HttpApiService
    private let favouritesStore: FavouriteStore
    private let eventStore: EventStore
    private let remoteUrl: URL
    
    init(apiService: HttpApiService, eventStore: EventStore, favouritesStore: FavouriteStore, remoteUrl: URL) {
        self.httpApiService = apiService
        self.eventStore = eventStore
        self.remoteUrl = remoteUrl
        self.favouritesStore = favouritesStore
    }
    
    func loadEvents(pageOffset: Int, completionHandler: @escaping (_: EventResult)->()) {
        let completeUrl = URL(string: self.remoteUrl.absoluteString + "?_page=\(pageOffset)")!
        self.httpApiService.getCodable(from: completeUrl, completionHandler: { (result: Result<[Event], HttpApiService.ApiError>) in
            
            switch result {
            case .success(let events):
                if  pageOffset == 1 {
                    // First page so clear out any existing data
                    self.eventStore.removeAllEvents()
                }
                
                if events.count >= 1 {
                    self.eventStore.addEvents(events)
                    completionHandler(.gotEvents)
                } else {
                    completionHandler(.gotFinalEvent)
                }
            case .failure(let error):
                switch error {
                case .connectionIssue:
                    if  pageOffset == 1 {
                        self.loadEventsFromFavourites()
                    }
                    completionHandler(.noInternet)
                default:
                    completionHandler(.failure(error))
                }
            }
        })
    }
    
    private func loadEventsFromFavourites() {
        self.eventStore.removeAllEvents()
        self.eventStore.addEvents(self.favouritesStore.allFavourites)
    }
    
}
