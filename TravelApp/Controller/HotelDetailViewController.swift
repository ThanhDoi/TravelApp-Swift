//
//  HotelDetailViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/7/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import DropDown

class HotelDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favoriteButton: UIButton!
    var rating: Int!
    var recommendRating: Int!
    var valueText = NSMutableAttributedString()
    var isRecommend = false {
        didSet {
            if isRecommend {
                numberOfRows = 7
            } else {
                numberOfRows = 8
            }
        }
    }
    var isRatedRecommend = false
    var hotel: Hotel!
    var banner: StatusBarNotificationBanner?
    var numberOfRows = 0
    var isAddingTrip = false
    var isNone = false
    var valueTextField: UITextField!
    var datePicker : UIDatePicker!
    var trip: Trip?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
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
            let ratingCell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingTableViewCell
            ratingCell.backgroundColor = UIColor.clear
            if self.rating != nil {
                ratingCell.cosmosView.rating = Double(self.rating)
            }
            ratingCell.cosmosView.didFinishTouchingCosmos = { [weak self] rating in
                self?.rating = Int(rating)
                self?.doRate(rating: rating)
            }
            return ratingCell
        case 3:
            if !isRecommend {
                let selectTripCell = tableView.dequeueReusableCell(withIdentifier: "SelectTripCell", for: indexPath) as! SelectTripTableViewCell
                selectTripCell.backgroundColor = UIColor.clear
                selectTripCell.fieldLabel.text = "Trip"
                selectTripCell.valueTextField.isHidden = true
                var dataSource = [String]()
                if let trip = trip {
                    dataSource = ["None"]
                    selectTripCell.button.setTitle(trip.name, for: .normal)
                } else {
                    dataSource.append(contentsOf: ["None", "Add a new Trip"])
                    for eachTrip in Item.shared.visitedTrips {
                        dataSource.append(eachTrip.name)
                    }
                }
                selectTripCell.ButtonHandler = {
                    let dropDown = DropDown()
                    dropDown.anchorView = selectTripCell.button.plainView
                    dropDown.dataSource = dataSource
                    dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        selectTripCell.button.setTitle(item, for: .normal)
                        if index == 0 {
                            if let trip = self.trip {
                                self.removeHotelFromTrip(trip: trip)
                            }
                            self.isNone = true
                            self.doUpdate(indexPath: indexPath)
                        }
                        else if index == 1 {
                            self.isNone = false
                            self.isAddingTrip = true
                            self.doUpdate(indexPath: indexPath)
                        } else {
                            self.addHotelToTrip(index: index)
                        }
                    }
                    dropDown.show()
                }
                return selectTripCell
            }
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = hotel.location
        case 4:
            if isAddingTrip {
                let selectTripCell = tableView.dequeueReusableCell(withIdentifier: "SelectTripCell", for: indexPath) as! SelectTripTableViewCell
                selectTripCell.backgroundColor = UIColor.clear
                selectTripCell.button.isHidden = true
                selectTripCell.fieldLabel.text = "Trip Name"
                selectTripCell.fieldLabel.isHidden = false
                selectTripCell.valueTextField.placeholder = "Enter trip name"
                selectTripCell.valueTextField.isHidden = false
                return selectTripCell
            }
            if !isRecommend {
                cell.fieldLabel.text = "Location"
                cell.valueLabel.text = hotel.location
            } else {
                cell.fieldLabel.text = "Price"
                cell.valueLabel.text = hotel.price
            }
        case 5:
            if isAddingTrip {
                let selectTripCell = tableView.dequeueReusableCell(withIdentifier: "SelectTripCell", for: indexPath) as! SelectTripTableViewCell
                selectTripCell.backgroundColor = UIColor.clear
                selectTripCell.button.isHidden = true
                selectTripCell.fieldLabel.text = "Start Date"
                selectTripCell.fieldLabel.isHidden = false
                selectTripCell.valueTextField.placeholder = "Enter start date"
                selectTripCell.valueTextField.isHidden = false
                selectTripCell.valueTextField.delegate = self
                return selectTripCell
            }
            if !isRecommend {
                cell.fieldLabel.text = "Price"
                cell.valueLabel.text = hotel.price
            } else {
                cell.fieldLabel.text = "Star"
                cell.valueLabel.text = hotel.star
            }
        case 6:
            if isAddingTrip {
                let selectTripCell = tableView.dequeueReusableCell(withIdentifier: "SelectTripCell", for: indexPath) as! SelectTripTableViewCell
                selectTripCell.backgroundColor = UIColor.clear
                selectTripCell.button.isHidden = true
                selectTripCell.fieldLabel.text = "End Date"
                selectTripCell.fieldLabel.isHidden = false
                selectTripCell.valueTextField.placeholder = "Enter end date"
                selectTripCell.valueTextField.isHidden = false
                selectTripCell.valueTextField.delegate = self
                return selectTripCell
            }
            if !isRecommend {
                cell.fieldLabel.text = "Star"
                cell.valueLabel.text = hotel.star
            } else {
                cell.fieldLabel.text = "Features"
                cell.valueLabel.text = hotel.features
            }
        case 7:
            if isAddingTrip {
                let selectTripCell = tableView.dequeueReusableCell(withIdentifier: "SelectTripCell", for: indexPath) as! SelectTripTableViewCell
                selectTripCell.backgroundColor = UIColor.clear
                selectTripCell.valueTextField.isHidden = true
                selectTripCell.fieldLabel.isHidden = true
                selectTripCell.button.setTitle("Create new trip", for: .normal)
                selectTripCell.button.isHidden = false
                selectTripCell.ButtonHandler = {
                    self.createNewTrip(indexPath: indexPath)
                }
                return selectTripCell
            }
            if !isRecommend {
                cell.fieldLabel.text = "Features"
                cell.valueLabel.text = hotel.features
            }
        case 8:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = hotel.location
        case 9:
            cell.fieldLabel.text = "Price"
            cell.valueLabel.text = hotel.price
        case 10:
            cell.fieldLabel.text = "Star"
            cell.valueLabel.text = hotel.star
        case 11:
            cell.fieldLabel.text = "Features"
            cell.valueLabel.text = hotel.features
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func removeHotelFromTrip(trip: Trip) {
        APIConnect.shared.requestAPI(urlRequest: Router.removeHotelFromTrip(trip.id, hotel.id)) { (isSuccess, json) in
            if isSuccess {
                let banner = StatusBarNotificationBanner(title: "Removed from trip", style: .success)
                banner.show()
            }
        }
    }
    
    func addHotelToTrip(index: Int) {
        let visitedTrip = Item.shared.visitedTrips[index - 2]
        APIConnect.shared.requestAPI(urlRequest: Router.addHotelToTrip(visitedTrip.id, hotel.id)) { (isSuccess, json) in
            if isSuccess {
                let banner = StatusBarNotificationBanner(title: "Added to Trip", style: .success)
                banner.show()
            }
        }
    }
    
    func createNewTrip(indexPath: IndexPath) {
        let tripNameCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 3, section: indexPath.section)) as! SelectTripTableViewCell
        let startDateCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 2, section: indexPath.section)) as! SelectTripTableViewCell
        let endDateCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as! SelectTripTableViewCell
        let tripName = tripNameCell.valueTextField.text
        var startDate = startDateCell.valueTextField.text
        var endDate = endDateCell.valueTextField.text
        if tripName == "" || startDate == "" || endDate == "" {
            let alertController = createAlertController(title: "Oops", mesage: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
            present(alertController, animated: true, completion: nil)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "MMM d, yyyy"
            let startDay = dateFormatter.date(from: startDate!)
            let endDay = dateFormatter.date(from: endDate!)
            dateFormatter.dateFormat = "YYYY-MM-dd"
            startDate = dateFormatter.string(from: startDay!)
            endDate = dateFormatter.string(from: endDay!)
            
            APIConnect.shared.requestAPI(urlRequest: Router.createTripByHotel(tripName!, startDate!, endDate!, hotel.id)) { (isSuccess, json) in
                if isSuccess {
                    let banner = StatusBarNotificationBanner(title: "Added new trip", style: .success)
                    banner.show()
                    self.hideAddingTripFields(indexPath: indexPath)
                }
            }
        }
    }
    
    func hideAddingTripFields(indexPath: IndexPath) {
        isAddingTrip = false
        let range = indexPath.row-3...indexPath.row
        let indexPaths = range.map { return IndexPath(row: $0, section: indexPath.section) }
        tableView.beginUpdates()
        numberOfRows = numberOfRows - 4
        tableView.deleteRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func doRate(rating: Double) {
        if self.isRecommend {
            APIConnect.shared.requestAPI(urlRequest: Router.rateHotelRecommend(hotel.id!, Int(rating))) { (isSuccess, json) in
                if isSuccess {
                    self.isRatedRecommend = true
                    self.banner?.show()
                    self.checkRate()
                }
            }
        } else {
            APIConnect.shared.requestAPI(urlRequest: Router.rateHotel(hotel.id!, Int(rating))) { (isSuccess, json) in
                if isSuccess {
                    self.banner?.show()
                    self.checkRate()
                }
            }
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
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        if Item.shared.bookmarkedHotels.contains(hotel.id) {
            favoriteButton.setImage(#imageLiteral(resourceName: "removefav"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        }
        banner = StatusBarNotificationBanner(title: "Rated", style: .success)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: UIButton) {
        if Item.shared.bookmarkedHotels.contains(hotel.id) {
            let index = Item.shared.bookmarkedHotels.index(of: hotel.id)
            Item.shared.bookmarkedHotels.remove(at: index!)
            UserDefaults.standard.set(Item.shared.bookmarkedHotels, forKey: "bookmarkedHotels")
            let banner = StatusBarNotificationBanner(title: "Remove from bookmarked hotels", style: .success)
            banner.show()
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
        } else {
            Item.shared.bookmarkedHotels.append(hotel.id)
            UserDefaults.standard.set(Item.shared.bookmarkedHotels, forKey: "bookmarkedHotels")
            let banner = StatusBarNotificationBanner(title: "Added to bookmarked hotels", style: .success)
            banner.show()
            favoriteButton.setImage(#imageLiteral(resourceName: "removefav"), for: .normal)
        }
    }
    
    func doUpdate(indexPath: IndexPath) {
        let range = indexPath.row+1...indexPath.row+4
        let indexPaths = range.map { return IndexPath(row: $0, section: indexPath.section) }
        tableView.beginUpdates()
        if isAddingTrip {
            if isNone {
                numberOfRows = numberOfRows - 4
                tableView.deleteRows(at: indexPaths, with: .automatic)
                isAddingTrip = false
            } else {
                numberOfRows += 4
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
        tableView.endUpdates()
    }
    
    func pickUpDate(_ textField : UITextField) {
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        valueTextField.text = dateFormatter1.string(from: datePicker.date)
        valueTextField.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        valueTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        valueTextField = textField
        self.pickUpDate(valueTextField)
    }
    
}
