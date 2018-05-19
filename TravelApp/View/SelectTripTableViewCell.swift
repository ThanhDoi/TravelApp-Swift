//
//  SelectTripTableViewCell.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/19/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class SelectTripTableViewCell: UITableViewCell {
    
    @IBOutlet var button: UIButton!
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var valueTextField: UITextField!
    var ButtonHandler: (() -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.ButtonHandler()
    }

}
