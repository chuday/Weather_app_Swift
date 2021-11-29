//
//  CitiesTableViewController.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit
import RealmSwift

class CitiesTableViewController: UITableViewController {
    
    var cities: Results<City>?
    var popularCities = ["Дубай", "Калифорния", "Сан Франциско"]
    var selectedCity: City?
    var token: NotificationToken?
    private let cellReuseIdentifier = "CityCell"
    private let headerReuseIdentifier = "CityHeader"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.register(UINib(nibName: "CityTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        
        pairTableAndRealm()
        
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        print("Realm is at \(realm.configuration.fileURL)")
        cities = realm.objects(City.self)
        token = cities?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cities?.count ?? 0
        } else if section == 1 {
            return popularCities.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let cities = cities {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CityTableViewCell
            
            let city = cities[indexPath.row]
            cell.titleLabel.text = city.name
            cell.showDisclosureArrow = true
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CityTableViewCell
            
            let city = popularCities[indexPath.row]
            cell.titleLabel.text = city
            cell.showDisclosureArrow = true
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            selectedCity = cities?[indexPath.row]
        } else if indexPath.section == 1 {
            let popularCityName = popularCities[indexPath.row]
            let realm = try! Realm()
            if let popularCity = realm.object(ofType: City.self, forPrimaryKey: popularCityName) {
                selectedCity = popularCity
            } else {
                selectedCity = addCity(name: popularCityName)
            }
        } else {
            return
        }
        performSegue(withIdentifier: "toWeather", sender: self)
    }
    
    @IBAction func addCIty(segue: UIStoryboardSegue) {
        
        if segue.identifier == "addCity",
           let sourceVC = segue.source as? AllCitiesTableViewController,
           let selectedCity = sourceVC.selectedCity {
            addCity(name: selectedCity)
        }
    }
    
    @discardableResult
    func addCity(name: String) -> City {
        let newCity = City()
        newCity.name = name
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(newCity, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
        return newCity
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toWeather",
           let destination = segue.destination as? WeatherViewController {
            destination.title = selectedCity?.name
            destination.city = selectedCity
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .delete
        } else {
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 0, let cities = cities {
            let realm = try! Realm()
            try? realm.write {
                realm.delete(cities[indexPath.row])
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && !(cities?.isEmpty ?? true) {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! CityTableViewHeader
            header.configure(text: "Избранные города")
            return header
        } else if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! CityTableViewHeader
            header.configure(text: "Популярные города")
            return header
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && !(cities?.isEmpty ?? true) || section == 1 {
            return 44
        } else {
            return 0
        }
    }
    
}
