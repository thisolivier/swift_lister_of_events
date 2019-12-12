//
//  EventsListViewProtocols.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

protocol EventsListViewControllerable: class {
    
    func updateRow(_ row: Int)
    
    func reloadRows()
    
}

protocol EventsListViewInteractorable {
    
    var countOfEvents: Int { get }
    
    func getFooterConfiguration() -> FooterViewConfiguration?
    
    func getEventCellConfiguration(forRow row: Int) -> EventsListDefaultCellConfiguration
    
    func retryInternetConnection()
    
}

struct EventsListDefaultCellConfiguration {
    
    let row: Int
    let image: UIImage
    let favouriteState: FavouriteState
    let title: String
    let subtitle: String
    let setFavouriteStateHandler: (_:Int, _: FavouriteState)->()
    let showButton: Bool
    
    static let empty: Self = {
        return Self(row: 0, image: UIImage(), favouriteState: .none, title: "", subtitle: "", setFavouriteStateHandler: {_,_ in }, showButton: false)
    }()
    
}
