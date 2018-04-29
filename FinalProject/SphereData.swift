//
//  SphereData.swift
//  FinalProject
//
//  Created by Alon Shprung on 4/24/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import Foundation
struct SphereData {
    
    var items = [Item]()
    
    mutating func addItem(title: String, siteLogoStringURL: String, imageStringURL: String, itemStringURL: String) {
        items.append(Item(title: title, siteLogoStringURL: siteLogoStringURL, imageStringURL: imageStringURL, itemStringURL: itemStringURL))
    }
    
    static func parseJsonDictionaryToSphereData(jsonDictionary: [String : Any]) -> SphereData? {
        var sphereData = SphereData()
        if let items = jsonDictionary["items"] as? [Dictionary<String,Any>] {
            for item in items {
                if let imageURL = item["thumbnail"] as? String,
                    let document = item["document"] as? Dictionary<String,Any>,
                    let url = document["url"] as? String,
                    let title = document["title"] as? String,
                    let site = document["site"] as? Dictionary<String,Any>,
                    let logos = site["logos"] as? Dictionary<String,Any>,
                    let siteLogoURL = logos["150x150"] as? String {
                    sphereData.addItem(title: title, siteLogoStringURL: siteLogoURL, imageStringURL: imageURL, itemStringURL: url)
                }
            }
            return sphereData
        } else {
            return nil
        }
    }
    
    struct Item {
        var title: String
        var siteLogoStringURL: String
        var imageStringURL: String
        var itemStringURL: String
    }
}
