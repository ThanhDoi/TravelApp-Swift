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
    var valueText = NSMutableAttributedString()
    var isRecommend = false
    var isRatedRecommend = false
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favoriteButton: UIButton!
    var hotel: Hotel!
    
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
            cell.valueLabel.attributedText = valueText
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "showRateSegue", sender: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
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
        if HotelList.shared.bookmarkedHotels.contains(hotel.id) {
            favoriteButton.setImage(#imageLiteral(resourceName: "removefav"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        }
        checkRate()
    }
    
    func checkRate() {
        valueText = NSMutableAttributedString()
        APIConnect.shared.requestAPI(urlRequest: Router.getHotelAvgRating(hotel.id!)) { (isSuccess, json) in
            if isSuccess {
                if json["nodata"] == 1 {
                    self.valueText.append(NSAttributedString(string: "Not rated by anyone"))
                } else {
                    let count = json["count"].int!
                    let average = json["average"].double!
                    self.valueText.append(NSAttributedString(string: "Score: \((average * 100).rounded()/100) by \(count) people"))
                    let rating = json["user_rating"].int!
                    if rating == -1 {
                        let rateNow = NSAttributedString(string: " Rate now", attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue])
                        let beenThere = NSAttributedString(string: "\nHave you been there?", attributes: [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 17.0)!])
                        let rateThisRecommend = NSAttributedString(string: "\nRate this recommend?", attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue])
                        self.navigationItem.rightBarButtonItem = nil
                        if !self.isRecommend {
                            self.valueText.append(beenThere)
                            self.valueText.append(rateNow)
                        } else {
                            if self.isRatedRecommend {
                                self.valueText.append(NSAttributedString(string: "\nYou rated \(self.rating!) this recommend"))
                                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rate", style: .done, target: self, action: #selector(self.rateButtonTapped))
                            } else {
                                self.valueText.append(rateThisRecommend)
                            }
                        }
                    } else {
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rate", style: .done, target: self, action: #selector(self.rateButtonTapped))
                        self.valueText.append(NSAttributedString(string: "\nYou rated \(rating)"))
                    }
                }
                self.tableView.reloadData()
            } else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rate", style: .done, target: self, action: #selector(self.rateButtonTapped))
                self.valueText.append(NSAttributedString(string: "Network error!"))
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func rateButtonTapped() {
        performSegue(withIdentifier: "showRateSegue", sender: self)
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        if HotelList.shared.bookmarkedHotels.contains(hotel.id) {
            let index = HotelList.shared.bookmarkedHotels.index(of: hotel.id)
            HotelList.shared.bookmarkedHotels.remove(at: index!)
            UserDefaults.standard.set(HotelList.shared.bookmarkedHotels, forKey: "bookmarkedHotels")
            let alertController = createAlertController(title: "Done", mesage: "Remove from bookmarked hotels")
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
            present(alertController, animated: true, completion: nil)
        } else {
            HotelList.shared.bookmarkedHotels.append(hotel.id)
            UserDefaults.standard.set(HotelList.shared.bookmarkedHotels, forKey: "bookmarkedHotels")
            let alertController = createAlertController(title: "Done", mesage: "Bookmarked this hotel")
            favoriteButton.setImage(#imageLiteral(resourceName: "removefav"), for: .normal)
            present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRateSegue" {
            if let destVC = segue.destination as? RatingViewController {
                APIConnect.shared.requestAPI(urlRequest: Router.getHotelRatedScore(hotel.id!)) { (isSuccess, json) in
                    if isSuccess {
                        let rated = json["rated"].int
                        destVC.ratingControl.rating = rated!
                    } else {
                        destVC.isWrong = true
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToDetail(segue: UIStoryboardSegue) {
        if segue.source is RatingViewController {
            if let senderVC = segue.source as? RatingViewController {
                self.rating = senderVC.ratingControl.rating
                if self.isRecommend {
                    APIConnect.shared.requestAPI(urlRequest: Router.rateHotelRecommend(hotel.id!, self.rating!)) { (isSuccess, json) in
                        if isSuccess {
                            let alertController = createAlertController(title: "Done", mesage: "Rated this hotel!")
                            self.isRatedRecommend = true
                            self.checkRate()
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            let alertController = createAlertController(title: "Oops", mesage: "Something went wrong. Please try again!")
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    APIConnect.shared.requestAPI(urlRequest: Router.rateHotel(hotel.id!, self.rating!)) { (isSuccess, json) in
                        if isSuccess {
                            let alertController = createAlertController(title: "Done", mesage: "Rated this hotel!")
                            self.checkRate()
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            let alertController = createAlertController(title: "Oops", mesage: "Something went wrong. Please try again!")
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
}
