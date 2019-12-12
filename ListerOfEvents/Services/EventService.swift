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
    private let eventStore: EventStore
    private let remoteUrl: URL
    
    init(apiService: HttpApiService, eventStore: EventStore, remoteUrl: URL) {
        self.httpApiService = apiService
        self.eventStore = eventStore
        self.remoteUrl = remoteUrl
    }
    
    func loadEvents(pageOffset: Int, completionHandler: @escaping (_: EventResult)->()) {
        // TODO: This isn't how to construct query strings, and you know it.
        let completeUrl = URL(string: self.remoteUrl.absoluteString + "?_page=\(pageOffset)")!
        self.httpApiService.getCodable(from: completeUrl, completionHandler: { (result: Result<[Event], HttpApiService.ApiError>) in
            switch result {
            case .success(let events):
                if events.count >= 1 {
                    self.eventStore.addEvents(events)
                    completionHandler(.gotEvents)
                } else {
                    completionHandler(.gotFinalEvent)
                }
            case .failure(let error):
                switch error {
                case .connectionIssue:
                    completionHandler(.noInternet)
                default:
                    completionHandler(.failure(error))
                }
            }
        })
    }
    
}
