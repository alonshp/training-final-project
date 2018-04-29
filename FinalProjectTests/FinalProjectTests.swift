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
    
    var sphereResponse = [String : Any]()
    
    var weatherWuJson: Any?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            let testBundle = Bundle(for: type(of: self))
            if let file = testBundle.url(forResource: "wu_response", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.weatherWuJson = json
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
        do {
            let testBundle = Bundle(for: type(of: self))
            if let file = testBundle.url(forResource: "sphere_response", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    sphereResponse = object
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
            if let sphereData = parseSphere() {
                XCTAssertEqual(sphereData.items[0].imageStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6IjMxY2E0ZWJmMDI3MGZmYzk1NDEwYjMwYmRkZWFhYjdhYmQ5MTg3NjYwYTVlOTRmNzFhYWQwZWMxZTNhYTc2OGMiLCJ3IjozODAsImgiOjI1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.webp")
                XCTAssertEqual(sphereData.items[0].siteLogoStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6ImY5ZDZhZWUwNzMyYTU3ODRiMTkxZjZhYmYyYmIyZjA2MjRkMDNkNTY5N2QyYzdmOGFlMWFjOTAyZjVmY2EzZTUiLCJ3IjoxNTAsImgiOjE1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.jpg")
                XCTAssertEqual(sphereData.items[0].title, "Waffle House shooting victims include college students and an employee")
                
                XCTAssertEqual(sphereData.items[9].imageStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6ImUxZTYzYTg1NDEwMjk3Yzc2NTlmNTJmMGRlN2NhZDRmNTMyMjkxYmQ2ZjM0ZDMzZjFkOGVkMTFjYzMxOTlkMGMiLCJ3IjozODAsImgiOjI1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.webp")
                XCTAssertEqual(sphereData.items[9].siteLogoStringURL, "http://images.outbrain.com/transform/v3/eyJpdSI6IjYwN2I5YmY1M2IxMDEzYTQwYzI1NzdhOWM0MmExZmVlYTUzNjY5ZDkxMjIwNTMwMGIwOWZmYzNmNTZjNzZmZTYiLCJ3IjoxNTAsImgiOjE1MCwiZCI6MS41LCJjcyI6MCwiZiI6MH0.jpg")
                XCTAssertEqual(sphereData.items[9].title, "Watch the First Trailer for Crazy Rich Asians Starring Constance Wu")
            } else {
                XCTFail()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func parseSphere() -> SphereData? {
        var sphereData = SphereData()
        if let items = sphereResponse["items"] as? [Dictionary<String,Any>] {
            for item in items {
                if let imageURL = item["thumbnail"] as? String,
                    let document = item["document"] as? Dictionary<String,Any>,
                    let title = document["title"] as? String,
                    let site = document["site"] as? Dictionary<String,Any>,
                    let logos = site["logos"] as? Dictionary<String,Any>,
                    let siteLogoURL = logos["150x150"] as? String {
                    sphereData.addItem(title: title, siteLogoStringURL: siteLogoURL, imageStringURL: imageURL)
                }
            }
            return sphereData
        } else {
            return nil
        }
    }
}
