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
        if let existingFavourites = userDefaults.array(forKey: self.favouritesKey) as? [Event] {
            self.favourites = existingFavourites
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
    
    func getAllFavourites() -> [Event] {
        return self.favourites
    }
    
    private func updatePeristentStorage() {
        DispatchQueue.global(qos: .background).async {
            self.userDefaults.set(self.favourites, forKey: self.favouritesKey)
        }
    }
    
}
