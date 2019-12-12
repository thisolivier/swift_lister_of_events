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
    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerConfiguration = self.interactor.getFooterConfiguration() {
            return 100
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerConfiguration = self.interactor.getFooterConfiguration() else {
            return nil
        }
        let footer = Bundle.main.loadNibNamed("FooterView", owner: nil, options: nil)![0] as! FooterView
        footer.configure(with: footerConfiguration)
        return footer
    }
    
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
        cell.configure(self.interactor.getEventCellConfiguration(forRow: indexPath.row))        
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
