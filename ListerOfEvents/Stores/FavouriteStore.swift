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
    
    private var favouritesById: [String] = []
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        if let existingFavourites = userDefaults.array(forKey: self.favouritesKey) as? [String] {
            self.favouritesById = existingFavourites
        } else {
            self.updatePeristentStorage()
        }
    }
    
    func setFavouriteState(id: String, state: FavouriteState) {
        print("saving the favourite state")
        let isInFavourites = self.favouritesById.contains(id)
        switch state {
        case .favourite:
            if !isInFavourites {
                self.favouritesById.append(id)
            }
        case .none:
            if isInFavourites {
                self.favouritesById.removeAll(where: { $0 == id })
            }
        }
    }
    
    func getFavouriteState(id: String) -> FavouriteState {
        switch self.favouritesById.contains(id) {
        case true:
            return .favourite
        case false:
            return .none
        }
    }
    
    private func updatePeristentStorage() {
        DispatchQueue.global(qos: .background).async {
            self.userDefaults.set(self.favouritesById, forKey: self.favouritesKey)
        }
    }
    
}
