//
//  EventService.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

class EventService {
    
    private let httpApiService: HttpApiService
    private let eventStore: EventStore
    private let remoteUrl: URL
    
    init(apiService: HttpApiService, eventStore: EventStore, remoteUrl: URL) {
        self.httpApiService = apiService
        self.eventStore = eventStore
        self.remoteUrl = remoteUrl
    }
    
    func loadEvents(pageOffset: Int, completionHandler: (_: Bool)->()) {
        let completeUrl = self.remoteUrl.appendingPathComponent("?_page=\(pageOffset)")
        self.httpApiService.getCodable(from: completeUrl, completionHandler: { (result: Result<[Event], Error>) in
            switch result {
            case .success(let events):
                self.eventStore.addEvents(events)
                completionHandler(true)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        })
    }
    
}
