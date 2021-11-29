//
//  NetworkManagerURLConfig.swift
//  Weather_app
//
//  Created by Mikhail Chudaev on 25.10.2021.
//

import Foundation

class NetworkManagerURLConfig {
    
    static let shared = NetworkManagerURLConfig()
    
    private init() { }
    
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    func getWetherURLSeesion(city: String) {
        var urlConstructor = URLComponents()
                urlConstructor.scheme = "http"
                urlConstructor.host = "samples.openweathermap.org"
                urlConstructor.path = "/data/2.5/forecast"
                urlConstructor.queryItems = [
                    URLQueryItem(name: "q", value: city),
                    URLQueryItem(name: "appid", value: "b1b15e88fa797225412429c1c50c122a1"),
                ]
                
        var request = URLRequest(url: urlConstructor.url!)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            print(json)
        }
        task.resume()
    }
    
}
