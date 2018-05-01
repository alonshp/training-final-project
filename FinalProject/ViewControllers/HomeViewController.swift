//
//  ViewController.swift
//  FinalProject
//
//  Created by Alon Shprung on 4/22/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit
import MBProgressHUD
import VideoSplashKit

class HomeViewController: VideoSplashViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var weatherLable: UILabel!
    @IBOutlet weak var temperatureLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWeatherData()
        
        addVideoSplash()
    }
    
    func addVideoSplash () {
        if let path = Bundle.main.path(forResource: "sunrise", ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            self.videoFrame = view.frame
            self.fillMode = .resizeAspectFill
            self.alwaysRepeat = true
            self.sound = false
            self.startTime = 35.0
            self.duration = 10.0
            self.alpha = 0.7
            self.backgroundColor = UIColor.black
            self.contentURL = url
            self.restartForeground = true
        }
    }
    
    func loadWeatherData(){
        let networkUtils = NetworkUtils()
        
        showLoadingHUD()
        networkUtils.fetchWeatherData() { (weatherData) in
            self.weatherLable.text = weatherData.weatherString
            self.temperatureLable.text = weatherData.temperature
            self.hideLoadingHUD()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: contentView, animated: true)
        hud.label.text = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hide(for: contentView, animated: true)
    }
}

