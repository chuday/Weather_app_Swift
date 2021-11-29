//
//  WeatherCollectionViewCell.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let dateFormatter: DateFormatter = {
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        
        return df
    }()
    
    func configure(withWeather weather: Weather) {
        
        let date = Date(timeIntervalSince1970: weather.date)
        let stringDate = WeatherCollectionViewCell.dateFormatter.string(from: date)
        
        tempLabel.text = String(weather.temp)
        dateLabel.text = stringDate
    }
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        tempLabel.text = ""
        dateLabel.text = ""
    }
}
