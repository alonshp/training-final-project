//
//  TableViewCell.swift
//  FinalProject
//
//  Created by Alon Shprung on 4/24/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class SphereTableViewCell: UITableViewCell {
    
    @IBOutlet weak var siteLogoImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var sphereItemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
