//
//  City.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 25.10.2021.
//

import Foundation
import RealmSwift

class City: Object {
    @objc dynamic var name = ""
    let weathers = List<Weather>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
