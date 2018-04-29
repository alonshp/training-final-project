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
    
    var weatherWuResponse = [String : Any]()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            let testBundle = Bundle(for: type(of: self))
            if let file = testBundle.url(forResource: "wu_response", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    weatherWuResponse = object
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
                XCTFail()
            }
        } catch {
            print(error.localizedDescription)
            XCTFail()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonToDictionary() {
        if let weatherData = WeatherData.parseJsonDictionaryToWeatherData(jsonDictionary: weatherWuResponse) {
            XCTAssertEqual(weatherData.weatherString , "Clear")
            XCTAssertEqual(weatherData.temperature , "50.8 F (10.4 C)")
        } else {
            XCTFail()
        }
    }
}
