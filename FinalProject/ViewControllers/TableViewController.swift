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

class TableViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    let dataSource = SphereTableDataSource()
    
    var offset = 0
    
    let networkUtils = NetworkUtils()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView!.estimatedRowHeight = 300
        
        loadSphereData()
        
        tableView.dataSource = self.dataSource
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
            self.tableView.reloadData()
            self.showSpinnerAtTheEndOfTheData()
        }
        updateOffset()
    }
    
    func getMoreData() {
        networkUtils.fetchSphereData(offset: offset) { (sphereData) in
            self.dataSource.items?.append(contentsOf: sphereData.items)
            let indexPaths = ((self.dataSource.items?.count)! - 10 ..< (self.dataSource.items?.count)!)
                .map { IndexPath(row: $0, section: 0) }
            self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        }
        updateOffset()
    }
    
    func showSpinnerAtTheEndOfTheData(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        self.tableView.tableFooterView = spinner;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItemInSafariViewController(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let items = self.dataSource.items {
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
        if let item = self.dataSource.items?[itemIndex],
        let url = URL(string: item.itemStringURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
