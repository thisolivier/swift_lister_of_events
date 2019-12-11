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
    weak var viewController: EventsListViewControllerable?
    
    private var nextPageToLoad = 1
    private var requesting: Bool = false
    
    init(imageService: ImageService, eventService: EventService, eventStore: EventStore, favouriteStore: FavouriteStore) {
        self.imageService = imageService
        self.eventService = eventService
        self.eventStore = eventStore
        self.favouriteStore = favouriteStore
    }
    
    var countOfEvents: Int {
        get {
            print("Getting count - are we main?", Thread.isMainThread)
            print("How many events have we?", self.eventStore.eventsCount)
            return self.eventStore.eventsCount
        }
    }
    
    func requestMoreEvents() {
        guard let viewController = self.viewController else {
            print("Attempted to use interactor with no view controller set")
            return
        }
        guard !self.requesting else {
            print("requestMoreEvents says 'yes I know'")
            return
        }
        self.requesting = true
        self.eventService.loadEvents(pageOffset: nextPageToLoad, completionHandler: { success in
            if success {
                self.nextPageToLoad += 1
                self.requesting = false
                viewController.reloadRows()
            }
        })
    }
    
    func setFavoriteState(onRow row: Int, favoriteState: FavouriteState) {
        guard let viewController = self.viewController else {
            print("Attempted to use interactor with no view controller set")
            return
        }
        guard let eventId = self.eventStore.getEvent(at: row)?.id else {
            print("No event at the requested row \(row) found. State was:", favoriteState)
            return
        }
        self.favouriteStore.setFavouriteState(id: eventId, state: favoriteState)
        viewController.updateRow(row)
    }
    
    func getEventAtRow(_ row: Int) -> EventsListDefaultCellConfiguration {
        guard let viewController = self.viewController else {
            print("Attempted to use interactor with no view controller set")
            return .empty
        }
        guard let event = self.eventStore.getEvent(at: row) else {
            print("🔥💀 - WARNING! No event at expected row! Row was: \(row)")
            return .empty
        }
        let subtitle = self.formatDate(event.startDate)
        
        let image: UIImage = {
            if let image = self.imageService.getFromCache(by: event.image) {
                return image
            } else {
                self.imageService.downloadImage(at: event.image, completionHandler: { success in
                    if success {
                        viewController.updateRow(row)
                    }
                })
                return UIImage.init()
            }
        }()
        
        let favoriteState = self.favouriteStore.getFavouriteState(id: event.id)
        let eventCellConfiguration = EventsListDefaultCellConfiguration(
            row: row,
            image: image,
            favouriteState: favoriteState,
            title: event.title,
            subtitle: subtitle,
            favouriteStateHandler: { [weak self] (row: Int, favouriteState: FavouriteState) in
                self?.setFavoriteState(onRow: row, favoriteState: favoriteState)
            }
        )
        return eventCellConfiguration
        
    }
    
    private func formatDate(_ date: Date) -> String {
        // TODO: This shouldn't be the interactor's job...
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "dddd t"
        dateFormatter.timeZone = .autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
    
}
