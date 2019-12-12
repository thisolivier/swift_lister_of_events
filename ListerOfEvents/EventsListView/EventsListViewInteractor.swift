//
//  EventsListViewInteractor.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

class EventsListViewInteractor: EventsListViewInteractorable {
    
    enum EventRequestState {
        case idle, requesting, exhausted, offline
    }
    
    private let imageService: ImageService
    private let eventService: EventService
    private let eventStore: EventStore
    private let favouriteStore: FavouriteStore
    weak var viewController: EventsListViewControllerable?
    
    private var nextPageToLoad = 1
    private var eventRequestState: EventRequestState = .idle
    private var shouldUseBackupData: Bool {
        return self.nextPageToLoad == 1 && self.eventRequestState == .offline
    }
    
    private var eventSource: EventSource {
        if self.shouldUseBackupData {
            return self.favouriteStore
        } else {
            return self.eventStore
        }
    }
    
    init(imageService: ImageService, eventService: EventService, eventStore: EventStore, favouriteStore: FavouriteStore) {
        self.imageService = imageService
        self.eventService = eventService
        self.eventStore = eventStore
        self.favouriteStore = favouriteStore
        self.requestMoreEvents()
    }
    
    var countOfEvents: Int {
        self.eventSource.eventsCount
    }
    
    func getEventCellConfiguration(forRow row: Int) -> EventsListDefaultCellConfiguration {
        guard let event = self.eventSource.getEvent(at: row) else {
            print("No event at expected row! Row was: \(row)")
            return .empty
        }
        
        DispatchQueue.global(qos: .background).async {
            if row + 5 > self.countOfEvents {
                self.requestMoreEvents()
            }
        }
        
        let image: UIImage = self.getImage(for: event.image, fromRow: row)
        let subtitle = self.formatDate(event.startDate)
        let favoriteState = self.favouriteStore.getFavouriteState(event: event)
        let eventCellConfiguration = EventsListDefaultCellConfiguration(
            row: row,
            image: image,
            favouriteState: favoriteState,
            title: event.title,
            subtitle: subtitle,
            setFavouriteStateHandler: { [weak self] (row: Int, newState: FavouriteState) in
                self?.setFavoriteState(onRow: row, favoriteState: newState)
            },
            showButton: !self.shouldUseBackupData
        )
        return eventCellConfiguration
    }
    
    func getFooterConfiguration() -> FooterViewConfiguration? {
        guard self.eventRequestState == .offline else {
            return nil
        }
        let message = self.nextPageToLoad == 1 ? "You are offline and will only see your favorites" : "You've lost connectivity"
        return FooterViewConfiguration(message: message, action: self.retryInternetConnection)
    }
    
    func retryInternetConnection() {
        guard self.eventRequestState == .offline else {
            return
        }
        self.eventRequestState = .idle
        self.requestMoreEvents()
        self.viewController?.reloadRows()
    }
    
    private func setFavoriteState(onRow row: Int, favoriteState: FavouriteState) {
        // TODO: Make work when offline
        guard self.eventRequestState != .offline && self.nextPageToLoad != 1 else {
            return
        }
        guard let event = self.eventSource.getEvent(at: row) else {
            print("No event at the requested row \(row) found. State was:", favoriteState)
            return
        }
        self.favouriteStore.setFavouriteState(event: event, state: favoriteState)
        viewController?.updateRow(row)
    }
    
    private func requestMoreEvents() {
        guard self.eventRequestState == .idle else {
            return
        }
        self.eventRequestState = .requesting
        self.eventService.loadEvents(pageOffset: nextPageToLoad, completionHandler: { result in
            switch result {
            case .gotEvents:
                self.nextPageToLoad += 1
                self.eventRequestState = .idle
                DispatchQueue.main.async {
                    self.viewController?.reloadRows()
                }
            case .gotFinalEvent:
                self.eventRequestState = .exhausted
            case .noInternet:
                self.eventRequestState = .offline
                DispatchQueue.main.async {
                    self.viewController?.reloadRows()
                }
            case .failure(_):
                self.eventRequestState = .idle
            }
        })
    }
    
    private func formatDate(_ date: Date) -> String {
        // TODO: This shouldn't be the interactor's job...
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "EEEE H:mm"
        dateFormatter.timeZone = .autoupdatingCurrent
        return dateFormatter.string(from: date)
    }
    
    private func getImage(for url: URL, fromRow row: Int) -> UIImage {
        if let image = self.imageService.getFromCache(by: url) {
            return image
        } else {
            self.imageService.downloadImage(at: url, completionHandler: { success in
                if success {
                    self.viewController?.updateRow(row)
                }
            })
            return UIImage.init()
        }
    }
    
}
