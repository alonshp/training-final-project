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
    
    mutating func addItem(title: String, siteLogoStringURL: String, imageStringURL: String) {
        items.append(Item(title: title, siteLogoStringURL: siteLogoStringURL, imageStringURL: imageStringURL))
    }
    
    struct Item {
        var title: String
        var siteLogoStringURL: String
        var imageStringURL: String
    }
}
