//
//  WeatherData.swift
//  FinalProject
//
//  Created by Alon Shprung on 4/24/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation

struct WeatherData {
    var weatherString: String
    var temperature: String
    
    static func parseJsonDictionaryToWeatherData(jsonDictionary: [String : Any]) -> WeatherData? {
        if let currentObservation = jsonDictionary["current_observation"] as? Dictionary<String,Any>,
            let weatherString = currentObservation["weather"] as? String,
            let temperature = currentObservation["temperature_string"] as? String {
            return WeatherData(weatherString: weatherString, temperature: temperature)
        } else {
            return nil
        }
    }
}
