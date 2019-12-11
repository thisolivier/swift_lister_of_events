//
//  EventsListViewInteractor.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

class EventsListViewInteractor: EventsListViewInteractorable {
    
    private let imageService: ImageService
    private let eventService: EventService
    private let eventStore: EventStore
    private let favouriteStore: FavouriteStore
    private let viewController: EventsListViewControllerable
    
    private var nextPageToLoad = 1
    
    init(imageService: ImageService, eventService: EventService, eventStore: EventStore, favouriteStore: FavouriteStore, viewController: EventsListViewControllerable) {
        self.imageService = imageService
        self.eventService = eventService
        self.eventStore = eventStore
        self.favouriteStore = favouriteStore
        self.viewController = viewController
    }
    
    var countOfEvents: Int {
        return self.eventStore.eventsCount
    }
    
    func loadNext() {
        self.eventService.loadEvents(pageOffset: nextPageToLoad, completionHandler: { success in
            if success {
                self.viewController.reloadRows()
            }
        })
    }
    
    func setFavoriteState(onRow row: Int, favoriteState: FavouriteState) {
        guard let eventId = self.eventStore.getEvent(at: row)?.id else {
            return
        }
        self.favouriteStore.setFavouriteState(id: eventId, state: favoriteState)
        self.viewController.updateRow(row)
    }
    
    func getEventAtRow(_ row: Int) -> EventsListDefaultCellConfiguration {
        guard let event = self.eventStore.getEvent(at: row) else {
            // panick!
            return
        }
        
        let subtitle = self.formatDate(event.startDate)
        
        let image: UIImage = {
            if let image = self.imageService.getFromCache(by: event.image) {
                return image
            } else {
                self.imageService.downloadImage(at: event.image, completionHandler: { success in
                    if success {
                        self.viewController.updateRow(row)
                    }
                })
                return UIImage.init()
            }
        }()
        
        let favoriteState = self.favouriteStore.getFavouriteState(id: event.id)
        let eventCellConfiguration = EventsListDefaultCellConfiguration(row: row, image: image, favouriteState: favoriteState, title: event.title, subtitle: subtitle, interactor: self)
        return eventCellConfiguration
        
    }
    
    private func formatDate(_ date: Date) -> String {
        return "Test"
    }
    
}
