//
//  CityTableViewCell.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBInspectable var showDisclosureArrow: Bool = false {
        didSet {
            if showDisclosureArrow {
                accessoryType = .disclosureIndicator
            } else {
                accessoryType = .none
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        showDisclosureArrow = false
    }

}
