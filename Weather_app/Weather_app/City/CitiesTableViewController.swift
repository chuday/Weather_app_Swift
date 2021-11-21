//
//  CitiesTableViewController.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    var cities = [String]()
    var popularCities = ["Нью Йорк", "Калифорния", "Сан Франциско"]
    var selectedCity: String?
    private let cellReuseIdentifier = "CityCell"
    private let headerReuseIdentifier = "CityHeader"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.register(UINib(nibName: "CityTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
        return cities.count
        } else if section == 1 {
            return popularCities.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CityTableViewCell
            
            let city = cities[indexPath.row]
            cell.titleLabel.text = city
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
            selectedCity = cities[indexPath.row]
        } else if indexPath.section == 1 {
            selectedCity = popularCities[indexPath.row]
        } else {
            return
        }
        performSegue(withIdentifier: "toWeather", sender: self)
    }
    
    @IBAction func addCIty(segue: UIStoryboardSegue) {
        
        if segue.identifier == "addCity",
           let sourceVC = segue.source as? AllCitiesTableViewController,
           let selectedCity = sourceVC.selectedCity {
            if !cities.contains(selectedCity) {
                cities.append(selectedCity)
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toWeather",
           let destination = segue.destination as? WeatherViewController {
            destination.title = selectedCity
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .delete
        } else {
            return .none
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 0 {
            cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && !cities.isEmpty {
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
        if section == 0 && !cities.isEmpty || section == 1 {
            return 44
        } else {
            return 0
        }
    }

}
