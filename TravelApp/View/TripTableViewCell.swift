//
//  TripTableViewCell.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/19/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
