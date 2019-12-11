//
//  EventsListViewController.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 11/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

class EventsListTableViewController: UITableViewController {
    
    let eventCellIdentifier = "defaultEventCell"
    
    var interactor: EventsListViewInteractorable!
    
    static func controller(interactor: EventsListViewInteractorable) -> EventsListTableViewController {
        guard let controller = UIStoryboard(name: "EventsListTableViewController", bundle: nil).instantiateInitialViewController() as? EventsListTableViewController else {
            fatalError("Storyboard data not found")
        }
        controller.interactor = interactor
        return controller
    }
    
    override func viewDidLoad() {
        print("My view loaded, I'm going to request some events")
        self.interactor.requestMoreEvents()
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.tableView == tableView else {
            return 0
        }
        return self.interactor.countOfEvents
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.tableView == tableView else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.eventCellIdentifier) as? EventsListDefaultTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(self.interactor.getEventAtRow(indexPath.row))
        
        DispatchQueue.global(qos: .background).async {
            if indexPath.row + 10 < self.interactor.countOfEvents {
                self.interactor.requestMoreEvents()
            }
        }
        
        return cell
    }
    
}

extension EventsListTableViewController: EventsListViewControllerable {
    
    func updateRow(_ row: Int) {
        self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
    
    func reloadRows() {
        self.tableView.reloadData()
    }
    
}