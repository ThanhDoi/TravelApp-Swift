//
//  AttractionDetailViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/18/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class AttractionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var attraction: Attraction!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AttractionDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = attraction.name
        case 1:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = attraction.location
        default:
            cell.fieldLabel.text = ""
            cell.fieldLabel.text = ""
        }
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
