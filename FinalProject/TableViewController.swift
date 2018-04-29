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

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentView: UIView!
    
    var items: [SphereData.Item]?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadSphereData()
    }
    
    func loadSphereData() {
        let networkUtils = NetworkUtils()
        
        showLoadingHUD()
        networkUtils.fetchSphereData() { (sphereData) in
            self.items = sphereData.items
            self.hideLoadingHUD()
            self.tableView.reloadData()
        }
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
        if let itemCell = cell as? TableViewCell,
            let item = items?[indexPath.row]{
            itemCell.titleLable.text = item.title
            if let siteLogoURL = URL(string: item.siteLogoStringURL),
                let imageURL = URL(string: item.imageStringURL) {
                itemCell.UISiteLogoImage.kf.setImage(with: siteLogoURL)
                itemCell.UIImage.kf.setImage(with: imageURL)
            }
        }
        return cell
    }

    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: contentView, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: contentView, animated: true)
    }
}
