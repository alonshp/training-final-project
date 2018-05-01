//
//  TableViewController.swift
//  FinalProject
//
//  Created by Alon Shprung on 4/24/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit
import MBProgressHUD
import Kingfisher
import SafariServices

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentView: UIView!
    
    var items: [SphereData.spherItem]?
    var offset = 0
    
    let networkUtils = NetworkUtils()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView!.estimatedRowHeight = 300
        
        loadSphereData()
        
    }
    
    func loadSphereData() {
        showLoadingHUD()
        networkUtils.fetchSphereData(offset: offset) { (sphereData) in
            self.items = sphereData.items
            self.hideLoadingHUD()
            self.tableView.reloadData()
            self.showSpinnerAtTheEndOfTheData()
        }
        offset += 10
    }
    
    func getMoreData() {
        networkUtils.fetchSphereData(offset: offset) { (sphereData) in
            self.items?.append(contentsOf: sphereData.items)
            let indexPaths = ((self.items?.count)! - 10 ..< (self.items?.count)!)
                .map { IndexPath(row: $0, section: 0) }
            self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        }
        offset += 10
    }
    
    func showSpinnerAtTheEndOfTheData(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        self.tableView.tableFooterView = spinner;
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItemInSafariViewController(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let items = self.items {
            if (indexPath.row == items.count - 1) {
                getMoreData() // network request to get more data
            }
        }
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
