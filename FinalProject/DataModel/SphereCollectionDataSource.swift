//
//  SphereCollectionDataSource.swift
//  FinalProject
//
//  Created by Alon Shprung on 5/1/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit
class SphereCollectionDataSource: NSObject,UICollectionViewDataSource {
    
    var items: [SphereData.spherItem]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = self.items {
            return items.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        if let itemCell = cell as? SphereCollectionViewCell,
            let item = items?[indexPath.item]{
            itemCell.titleLabel.text = item.title
            if let siteLogoURL = URL(string: item.siteLogoStringURL),
                let imageURL = URL(string: item.imageStringURL) {
                itemCell.siteLogoImageView.kf.setImage(with: siteLogoURL)
                itemCell.sphereItemImageView.kf.setImage(with: imageURL)
            }
        }
        return cell
    }
}
