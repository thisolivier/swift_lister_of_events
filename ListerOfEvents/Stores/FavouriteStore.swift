//
//  FavouritePersistentStore.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import Foundation

class FavouriteStore {
    
    private let userDefaults: UserDefaults
    private let favouritesKey: String = "favourites"
    
    private var favourites: [Event]
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let decoder = JSONDecoder()
        if let data = userDefaults.object(forKey: self.favouritesKey) as? Data,
            let eventsFromStorage = try? decoder.decode([Event].self, from: data) {
            self.favourites = eventsFromStorage
        } else {
            self.favourites = []
            self.updatePeristentStorage()
        }
    }
    
    func setFavouriteState(event: Event, state: FavouriteState) {
        print("saving the favourite state")
        let isInFavourites = self.favourites.contains(where: { $0 == event })
        switch state {
        case .favourite:
            if !isInFavourites {
                self.favourites.append(event)
                self.updatePeristentStorage()
            }
        case .none:
            if isInFavourites {
                self.favourites.removeAll(where: { $0 == event })
                self.updatePeristentStorage()
            }
        }
    }
    
    func getFavouriteState(event: Event) -> FavouriteState {
        switch self.favourites.contains(event) {
        case true:
            return .favourite
        case false:
            return .none
        }
    }
    
    private func updatePeristentStorage() {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? JSONEncoder().encode(self.favourites) else {
                fatalError()
            }
            self.userDefaults.set(data, forKey: self.favouritesKey)
        }
    }
    
}

extension FavouriteStore: EventSource {
    
    var eventsCount: Int {
        return self.favourites.count
    }
    
    func getEvent(at index: Int) -> Event? {
        guard self.favourites.count > index else {
            return nil
        }
        return self.favourites[index]
    }
    
}
