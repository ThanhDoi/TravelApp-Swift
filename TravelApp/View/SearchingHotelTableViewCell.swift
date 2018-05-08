//
//  SearchingHotelTableViewCell.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/6/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class HotelTableViewCell: UITableViewCell {
    
    @IBOutlet var hotelImageView: UIImageView!
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var hotelLocationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
