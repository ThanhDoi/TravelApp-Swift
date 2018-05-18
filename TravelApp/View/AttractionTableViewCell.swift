//
//  AttractionTableViewCell.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/18/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class AttractionTableViewCell: UITableViewCell {
    
    @IBOutlet var attractionImageView: UIImageView!
    @IBOutlet var attractionNameLabel: UILabel!
    @IBOutlet var attractionLocationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
