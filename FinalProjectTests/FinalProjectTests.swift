//
//  FinalProjectTests.swift
//  FinalProjectTests
//
//  Created by Alon Shprung on 4/22/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import XCTest
@testable import FinalProject


class FinalProjectTests: XCTestCase {
    var weatherWuJson: Any?
    var sphereJson: Any?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            let testBundle = Bundle(for: type(of: self))
            if let weatherFile = testBundle.url(forResource: "wu_response", withExtension: "json") {
                let data = try Data(contentsOf: weatherFile)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.weatherWuJson = json
            } else {
                print("no file")
                XCTFail()
            }
            if let sphereFile = testBundle.url(forResource: "sphere_response", withExtension: "json") {
                let data = try Data(contentsOf: sphereFile)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.sphereJson = json
            } else {
                print("no file")
                XCTFail()
            }
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    func testJsonToDictionary() {
        var weatherWuResponse = [String : Any]()
        
        if let object = self.weatherWuJson as? [String: Any] {
            weatherWuResponse = object
        } else {
            print("JSON is invalid")
            XCTFail()
        }
        if let weatherData = WeatherData.parseJsonDictionaryToWeatherData(jsonDictionary: weatherWuResponse) {
            XCTAssertEqual(weatherData.weatherString , "Clear")
            XCTAssertEqual(weatherData.temperature , "50.8 F (10.4 C)")
        } else {
            XCTFail()
        }
    }
    
    func testSphereResponseJsonToDictionary() {
        var sphereResponse = [String : Any]()
        
        if let object = self.sphereJson as? [String: Any] {
            sphereResponse = object
        } else {
            print("JSON is invalid")
        }

        if let sphereData = SphereData.parseSphere(jsonDictionary: sphereResponse){
            XCTAssertEqual(sphereData.items[0].imageStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6IjMxY2E0ZWJmMDI3MGZmYzk1NDEwYjMwYmRkZWFhYjdhYmQ5MTg3NjYwYTVlOTRmNzFhYWQwZWMxZTNhYTc2OGMiLCJ3IjozODAsImgiOjI1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.webp")
            XCTAssertEqual(sphereData.items[0].siteLogoStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6ImY5ZDZhZWUwNzMyYTU3ODRiMTkxZjZhYmYyYmIyZjA2MjRkMDNkNTY5N2QyYzdmOGFlMWFjOTAyZjVmY2EzZTUiLCJ3IjoxNTAsImgiOjE1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.jpg")
            XCTAssertEqual(sphereData.items[0].title, "Waffle House shooting victims include college students and an employee")
            
            XCTAssertEqual(sphereData.items[9].imageStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6ImUxZTYzYTg1NDEwMjk3Yzc2NTlmNTJmMGRlN2NhZDRmNTMyMjkxYmQ2ZjM0ZDMzZjFkOGVkMTFjYzMxOTlkMGMiLCJ3IjozODAsImgiOjI1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.webp")
            XCTAssertEqual(sphereData.items[9].siteLogoStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6IjYwN2I5YmY1M2IxMDEzYTQwYzI1NzdhOWM0MmExZmVlYTUzNjY5ZDkxMjIwNTMwMGIwOWZmYzNmNTZjNzZmZTYiLCJ3IjoxNTAsImgiOjE1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.jpg")
            XCTAssertEqual(sphereData.items[9].title, "Watch the First Trailer for Crazy Rich Asians Starring Constance Wu")
        } else {
            XCTFail()
        }
    }
}
