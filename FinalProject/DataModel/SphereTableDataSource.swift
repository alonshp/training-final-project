//
//  SphereTableDataSource.swift
//  FinalProject
//
//  Created by Alon Shprung on 5/1/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit
class SphereTableDataSource: NSObject,UITableViewDataSource {
    
    var items: [SphereData.spherItem]?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.items {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if let itemCell = cell as? SphereTableViewCell,
            let item = items?[indexPath.row]{
            itemCell.titleLable.text = item.title
            if let siteLogoURL = URL(string: item.siteLogoStringURL),
                let imageURL = URL(string: item.imageStringURL) {
                itemCell.siteLogoImageView.kf.setImage(with: siteLogoURL)
                itemCell.sphereItemImageView.kf.setImage(with: imageURL)
            }
        }
        return cell
    }
}
