//
//  ForecastTableViewCell.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/9/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet var weatherIconImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
