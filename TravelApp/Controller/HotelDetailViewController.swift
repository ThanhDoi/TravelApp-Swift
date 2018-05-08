//
//  HotelDetailViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/7/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class HotelDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rating: Int!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotelDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = hotel.name
        case 1:
            cell.fieldLabel.text = "Rating"
            let url = "http://127.0.0.1:8000/api/hotels/\(hotel.id!)/ratingScore"
            let headers = ["Accept": "application/json",
                           "Content-Type": "application/json"]
            APIConnect.shared.requestAPI(url: url, method: .get, headers: headers) { (json) in
                if json["nodata"] == 1 {
                    cell.valueLabel.text = "Not rated by anyone"
                } else {
                    let count = json["count"].int!
                    let average = json["average"].double!
                    cell.valueLabel.text = "Score: \((average * 100).rounded()/100) by \(count) people"
                }
            }
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = hotel.location
        case 3:
            cell.fieldLabel.text = "Price"
            cell.valueLabel.text = hotel.price
        case 4:
            cell.fieldLabel.text = "Star"
            cell.valueLabel.text = hotel.star
        case 5:
            cell.fieldLabel.text = "Features"
            cell.valueLabel.text = hotel.features
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    var hotel: Hotel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if hotel.img != nil {
            imageView.image = UIImage(data: hotel.img!)
        } else {
            imageView.image = #imageLiteral(resourceName: "imagenotfound")
        }
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rate", style: .done, target: self, action: #selector(rateButtonTapped))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func rateButtonTapped() {
        performSegue(withIdentifier: "showRateSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRateSegue" {
            if let destVC = segue.destination as? RatingViewController {
                let url = "http://127.0.0.1:8000/api/hotels/\(hotel.id!)/ratedScore"
                let parameters = ["user_id": User.shared.user_id!]
                let headers = ["Accept": "application/json",
                               "Content-Type": "application/json"]
                APIConnect.shared.requestAPI(url: url, method: .get, parameters: parameters, headers: headers) { (json) in
                    let rated = json["rated"].int
                    destVC.ratingControl.rating = rated!
                }
            }
        }
    }
    
    @IBAction func unwindToDetail(segue: UIStoryboardSegue) {
        if segue.source is RatingViewController {
            if let senderVC = segue.source as? RatingViewController {
                self.rating = senderVC.ratingControl.rating
                let url = "http://127.0.0.1:8000/api/hotels/\(hotel.id!)/rate"
                let parameters = ["user_id": User.shared.user_id!, "rate": self.rating!]
                let headers = ["Accept": "application/json",
                               "Content-Type": "application/json"]
                APIConnect.shared.requestAPI(url: url, method: .post, parameters: parameters, encoding: "JSON", headers: headers) { (json) in
                    self.tableView.reloadData()
                }
            }
        }
    }

}
