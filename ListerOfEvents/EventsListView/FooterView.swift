//
//  FooterView.swift
//  ListerOfEvents
//
//  Created by Olivier Butler on 12/12/2019.
//  Copyright © 2019 Olivier Butler. All rights reserved.
//

import UIKit

struct FooterViewConfiguration {
    let message: String
    let action: ()->()
}

class FooterView: UIView {
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var footerButton: UIButton!
    
    private var action: (()->())?
    
    func configure(with configuration: FooterViewConfiguration) {
        self.footerLabel.text = configuration.message
        self.action = configuration.action
    }
    
    @IBAction func didTapFooterButton(_ sender: Any) {
        self.action?()
    }
    
}
