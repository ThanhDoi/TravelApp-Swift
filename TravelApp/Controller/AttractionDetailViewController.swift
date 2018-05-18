//
//  AttractionDetailViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/18/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class AttractionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var attraction: Attraction!
    var isRecommend = false
    var isRatedRecommend = false
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favoriteButton: UIButton!
    var banner: StatusBarNotificationBanner?
    var valueText = NSMutableAttributedString()
    var rating: Int!
    var recommendRating: Int!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AttractionDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = attraction.name
        case 1:
            cell.fieldLabel.text = "Rating"
            cell.valueLabel.attributedText = valueText
        case 2:
            let ratingCell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingTableViewCell
            ratingCell.backgroundColor = UIColor.clear
            if self.rating != nil {
                ratingCell.cosmosView.rating = Double(rating)
            }
            ratingCell.cosmosView.didFinishTouchingCosmos = { [weak self] rating in
                self?.rating = Int(rating)
                self?.doRate(rating: rating)
            }
            
            return ratingCell
        case 3:
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
        if attraction.img != nil {
            imageView.image = UIImage(data: attraction.img!)
        } else {
            imageView.image = #imageLiteral(resourceName: "imagenotfound")
        }
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if Item.shared.bookmarkedAttractions.contains(attraction.id) {
            favoriteButton.setImage(#imageLiteral(resourceName: "removefav"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        }
        
        banner = StatusBarNotificationBanner(title: "Rated", style: .success)
        checkRate()
    }
    
    func checkRate() {
        valueText = NSMutableAttributedString()
        APIConnect.shared.requestAPI(urlRequest: Router.getAttractionAvgRating(attraction.id)) { (isSuccess, json) in
            if isSuccess {
                if json["nodata"] == 1 {
                    self.valueText.append(NSAttributedString(string: "Not rated by anyone"))
                } else {
                    let count = json["count"].int!
                    let average = json["average"].double!
                    self.valueText.append(NSAttributedString(string: "Score: \((average * 100).rounded()/100) by \(count) people"))
                    self.rating = json["user_rating"].int!
                    self.recommendRating = json["user_recommend_rating"].int!
                    if self.rating == -1 {
                        let rateNow = NSAttributedString(string: " Rate now", attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue])
                        let beenThere = NSAttributedString(string: "\nHave you been there?", attributes: [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Italic", size: 17.0)!])
                        let rateThisRecommend = NSAttributedString(string: "\nRate this recommend?", attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue])
                        if self.isRecommend {
                            if self.recommendRating != -1 {
                                self.valueText.append(NSAttributedString(string: "\nYou rated \(self.recommendRating!) this recommend"))
                                self.rating = self.recommendRating
                            } else {
                                self.valueText.append(rateThisRecommend)
                            }
                        } else {
                            self.valueText.append(beenThere)
                            self.valueText.append(rateNow)
                        }
                    }
                }
            } else {
                self.valueText.append(NSAttributedString(string: "Network error!"))
            }
            self.tableView.reloadData()
        }
    }
    
    func doRate(rating: Double) {
        if self.isRecommend {
            APIConnect.shared.requestAPI(urlRequest: Router.rateAttractionRecommend(attraction.id!, Int(rating))) { (isSuccess, json) in
                if isSuccess {
                    self.isRatedRecommend = true
                    self.banner?.show()
                    self.checkRate()
                }
            }
        } else {
            APIConnect.shared.requestAPI(urlRequest: Router.rateAttraction(attraction.id!, Int(rating))) { (isSuccess, json) in
                if isSuccess {
                    self.banner?.show()
                    self.checkRate()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        if Item.shared.bookmarkedAttractions.contains(attraction.id) {
            let index = Item.shared.bookmarkedAttractions.index(of: attraction.id)
            Item.shared.bookmarkedAttractions.remove(at: index!)
            UserDefaults.standard.set(Item.shared.bookmarkedAttractions, forKey: "bookmarkedAttractions")
            let banner = StatusBarNotificationBanner(title: "Remove from bookmarked attractions", style: .success)
            banner.show()
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        } else {
            Item.shared.bookmarkedAttractions.append(attraction.id)
            UserDefaults.standard.set(Item.shared.bookmarkedAttractions, forKey: "bookmarkedAttractions")
            let banner = StatusBarNotificationBanner(title: "Added to bookmarked attractions", style: .success)
            banner.show()
            favoriteButton.setImage(#imageLiteral(resourceName: "removefav"), for: .normal)
        }
    }

}
