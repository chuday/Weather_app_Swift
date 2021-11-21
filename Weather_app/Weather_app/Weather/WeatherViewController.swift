//
//  WeatherViewController.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

struct WeatherData {
    var temp: Int
    var date: String
}

class WeatherViewController: UIViewController {
    
    var weathers = [WeatherData]()
    private var cellReuseIdentifier = "WeatherCell"
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var dayPicker: DayPicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        weathers = [
            WeatherData(temp: 34, date: "11.11.2011"),
            WeatherData(temp: 4, date: "12.11.2011"),
            WeatherData(temp: 33, date: "13.11.2011"),
            WeatherData(temp: 21, date: "14.11.2011"),
            WeatherData(temp: 5, date: "15.11.2011"),
            WeatherData(temp: 12, date: "16.11.2011")
        ]
        
    }
    
    @IBAction func dayDidChanche(sender: DayPicker) {
        print("\(sender.selectedDay?.title ?? "")")
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! WeatherCollectionViewCell
        let weather = weathers[indexPath.item]
        cell.tempLabel.text = "\(weather.temp)"
        cell.dateLabel.text = weather.date
        
        return cell
    }
}
