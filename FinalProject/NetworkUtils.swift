//
//  Utils.swift
//  FinalProject
//
//  Created by Alon Shprung on 4/22/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation
import Alamofire


struct NetworkUtils {
    
    var weatherStringURL = "https://api.wunderground.com/api/7b1d7f2dda02088f/conditions/q/CA/San_Francisco.json"
    
    mutating func fetchWeatherData(completion: @escaping (_ weatherData: WeatherData) -> Void) {
        guard let url = URL(string: weatherStringURL) else {
            return
        }
        Alamofire.request(url,method: .get).responseJSON { response in
            if let json = response.result.value {
                if let object = json as? [String: Any] {
                    if let weatherData = WeatherData.parseJsonDictionaryToWeatherData(jsonDictionary: object) {
                        completion(weatherData)
                    }
                }
            }
        }
    }
    
    init() {
        
    }
}
