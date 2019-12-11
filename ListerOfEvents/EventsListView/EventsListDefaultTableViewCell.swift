//
//  EventsListDefaultCellView.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

class EventsListDefaultTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventSubtitle: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    private var row: Int?
    private var favouriteStateHandler: ((_: Int, _: FavouriteState)->())?
    private var favouriteState: FavouriteState?
    
    func configure(_ configuration: EventsListDefaultCellConfiguration) {
        self.eventTitle.text = configuration.title
        self.eventSubtitle.text = configuration.subtitle
        self.eventImage.image = configuration.image
        self.row = configuration.row
        self.favouriteState = configuration.favouriteState
        self.favouriteStateHandler = configuration.favouriteStateHandler
    }
    
    override func prepareForReuse() {
        self.row = nil
        self.favouriteState = nil
        self.favouriteStateHandler = nil
        self.eventImage.image = nil
        self.eventTitle.text = ""
        self.eventSubtitle.text = ""
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        guard
            let oldFavouriteState = self.favouriteState,
            let myRow = self.row,
            let handler = self.favouriteStateHandler
            else {
                return
        }
        let newFavouriteState: FavouriteState = {
            switch oldFavouriteState {
            case .favourite: return .none
            case .none: return .favourite
            }
        }()
        handler(myRow, newFavouriteState)
    }
    
}
