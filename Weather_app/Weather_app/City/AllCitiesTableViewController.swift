//
//  AllCitiesTableViewController.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import UIKit

class AllCitiesTableViewController: UITableViewController {

    var cities = [
        "Москва",
        "Екатеринбург",
        "Ростов",
        "Самара",
        "Псков"
        ]
    
    var selectedCity: String?
    private let cellReuseIdentifier = "CityCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CityTableViewCell
        
        let city = cities[indexPath.row]
        cell.titleLabel.text = city

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCity = cities[indexPath.row]
        performSegue(withIdentifier: "addCity", sender: self)
    }

}
