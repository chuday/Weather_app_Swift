//
//  NetworkManager.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 25.10.2021.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    private let baseUrl = "http://api.openweathermap.org"
    private let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    private enum Endpoint: String {
        case forecast = "/data/2.5/forecast"
    }
    
    func loadWeatherData(city: String) {
        
        let path = Endpoint.forecast.rawValue
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": apiKey
        ]
        
        let url = baseUrl+path
        
        Session.custom.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            guard let data = response.value else { return }
            let weather = try! JSONDecoder().decode(WeatherResponse.self, from: data).list
            
            weather.forEach { $0.city = city }
            
            self?.saveWeatherData(weather, city: city)
        }
    }
    
    func saveWeatherData(_ weathers: [Weather], city: String) {
        do {
            let realm = try Realm()
            guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
            let oldWeathers = city.weathers
            realm.beginWrite()
            realm.delete(oldWeathers)
            city.weathers.append(objectsIn: weathers)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

extension Session {
    static let custom: Session = {
        let configuration = URLSessionConfiguration.default
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
}
