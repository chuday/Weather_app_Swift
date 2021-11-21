//
//  Day.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 15.10.2021.
//

import Foundation

enum Day: Int {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    static let allDays: [Day] = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    
    var title: String {
        switch self {
            case .monday: return "ПН"
            case .tuesday: return "ВТ"
            case .wednesday: return "СР"
            case .thursday: return "ЧТ"
            case .friday: return "ПТ"
            case .saturday: return "СБ"
            case .sunday: return "ВС"
        }
    }
}
