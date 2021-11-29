//
//  WeatherViewController.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var dayPicker: DayPicker!
    
    private var cellReuseIdentifier = "WeatherCell"
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()
    
    var city: City!
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        token = city.weathers.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.collectionView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.insertItems(at: insertions.map({ IndexPath(item: $0, section: 0)}))
                    self?.collectionView.deleteItems(at: deletions.map({ IndexPath(item: $0, section: 0)}))
                    self?.collectionView.reloadItems(at: modifications.map({ IndexPath(item: $0, section: 0)}))
                }, completion: nil)
                
            case .error(let error):
                print(error)
            }
            print("данные изменились")
        }
        
        NetworkManager.shared.loadWeatherData(city: city.name)
        
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    @IBAction func dayDidChanche(sender: DayPicker) {
        print("\(sender.selectedDay?.title ?? "")")
    }
    
    deinit {
        token?.invalidate()
    }
    
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return city.weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! WeatherCollectionViewCell
        let weather = city.weathers[indexPath.item]
        cell.configure(withWeather: weather)
        
        return cell
    }
}
