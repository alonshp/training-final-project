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
    
    let weatherStringURL = "https://api.wunderground.com/api/7b1d7f2dda02088f/conditions/q/CA/San_Francisco.json"
    let sphereStringURL = "https://sphere-dev.outbrain.com/api/v1/recommendations/documents"
    let sphereAuthorizationKey = "API_KEY c2e75315550543fdbf0a85e9a96a458e"
    let sphereUserID = "9afa6143-4357-4b27-8311-a3d4626259c7"

    
    func fetchWeatherData(completion: @escaping (_ weatherData: WeatherData) -> Void) {
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
    
    func fetchSphereData(offset: Int, completion: @escaping (_ sphereData: SphereData) -> Void) {
        guard let url = URL(string: sphereStringURL) else {
            return
        }
        let params: Parameters = ["limit": 10, "offset": offset]
        let headers: HTTPHeaders = [
            "Authorization" : sphereAuthorizationKey,
            "X-USER-ID" : sphereUserID
        ]
        
        Alamofire.request(url, parameters: params, headers: headers).responseJSON { response in
            if let json = response.result.value {
                if let object = json as? [String: Any] {
                    if let sphereData = SphereData.parseJsonDictionaryToSphereData(jsonDictionary: object) {
                        completion(sphereData)
                    }
                }
            }
        }
    }
    
    init() {
        
    }
}
