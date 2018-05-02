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

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var contentView: UIView!
    
    let dataSource = SphereCollectionDataSource()
    
    let networkUtils = NetworkUtils()
    var offset = 0

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSphereData()
        
        collectionView.dataSource = self.dataSource
    }
    
    private func updateOffset() {
        if let items = self.dataSource.items {
            self.offset += items.count
        }
    }
    
    func loadSphereData() {
        showLoadingHUD()
        networkUtils.fetchSphereData(offset: offset) { (sphereData) in
            self.dataSource.items = sphereData.items
            self.hideLoadingHUD()
            self.collectionView.reloadData()
            self.updateOffset()
        }
    }
    
    func getMoreData() {
        networkUtils.fetchSphereData(offset: offset) { (sphereData) in
            self.dataSource.items?.append(contentsOf: sphereData.items)
            self.collectionView.reloadData()
            self.updateOffset()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation == .portrait {
            return CGSize(width: collectionView.frame.width, height: 300)
        } else {
            return CGSize(width: (collectionView.frame.width - 20) / 2, height: 300)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let items = self.dataSource.items {
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
        if let item = self.dataSource.items?[itemIndex],
            let url = URL(string: item.itemStringURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }

}
