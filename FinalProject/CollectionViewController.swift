//
//  CollectionViewController.swift
//  FinalProject
//
//  Created by Alon Shprung on 4/29/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit
import MBProgressHUD
import Kingfisher
import SafariServices

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var contentView: UIView!
    
    var items: [SphereData.Item]?
    let networkUtils = NetworkUtils()

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSphereData()
    }
    
    func loadSphereData() {
        showLoadingHUD()
        networkUtils.fetchSphereData() { (sphereData) in
            self.items = sphereData.items
            self.hideLoadingHUD()
            self.collectionView.reloadData()
        }
    }
    
    func getMoreData() {
        networkUtils.fetchSphereData() { (sphereData) in
            self.items?.append(contentsOf: sphereData.items)
            self.collectionView.reloadData()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if let items = self.items {
            return items.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
        if let itemCell = cell as? CollectionViewCell,
            let item = items?[indexPath.item]{
            itemCell.titleLable.text = item.title
            if let siteLogoURL = URL(string: item.siteLogoStringURL),
                let imageURL = URL(string: item.imageStringURL) {
                itemCell.logoImage.kf.setImage(with: siteLogoURL)
                itemCell.itemImage.kf.setImage(with: imageURL)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let items = self.items {
            if (indexPath.row == items.count - 1) {
                getMoreData() // network request to get more data
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showItemInSafariViewController(indexPath.item)
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: contentView, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: contentView, animated: true)
    }
    
    func showItemInSafariViewController(_ itemIndex: Int) {
        if let item = items?[itemIndex],
            let url = URL(string: item.itemStringURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }

}
