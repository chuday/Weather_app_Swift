//
//  WeatherCollectionViewCell.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        tempLabel.text = ""
        dateLabel.text = ""
    }
}
