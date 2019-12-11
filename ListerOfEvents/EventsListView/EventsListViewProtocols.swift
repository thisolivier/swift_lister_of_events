//
//  EventsListViewProtocols.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

protocol EventsListViewControllerable {
    
    func updateRow(_ row: Int)
    
    func reloadRows()
    
}

protocol EventsListViewInteractorable {
    
    var countOfEvents: Int { get }
    
    func loadNext()
    
    func setFavoriteState(onRow row: Int, favoriteState: FavouriteState)
    
    func getEventAtRow(_ row: Int) -> EventsListDefaultCellConfiguration
    
}

struct EventsListDefaultCellConfiguration {
    
    let row: Int
    let image: UIImage
    let favouriteState: FavouriteState
    let title: String
    let subtitle: String
    let interactor: EventsListViewInteractorable
    
}
