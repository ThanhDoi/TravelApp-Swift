//
//  AccountPopoverViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 4/29/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccountPopoverViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.white.cgColor
        logoutButton.layer.cornerRadius = 10
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        nameTextField.text = User.shared.name
        emailTextField.text = User.shared.email
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        nameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        confirmPasswordTextField.isEnabled = false
        updateButton.isEnabled = false
    }
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if checkFields() {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let name = (nameTextField.text)!
            let password = (passwordTextField.text)!
            let api_token = User.shared.api_token!
            let id = User.shared.user_id!
            let url = "http://127.0.0.1:8000/api/users/\(id)"
            print(url)
            let parameters = ["name": name, "password": password]
            let headers = ["Accept": "application/json",
                           "Content-Type": "application/json",
                           "Authorization": "Bearer \(api_token)"]
            if !checkPassword() {
                let alertController = UIAlertController(title: "Oops", message: "Confirmation password does not match. Please check.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(true, forKey: "hasSignedIn")
                APIConnect.shared.requestAPI(url: url, method: .put, parameters: parameters, encoding: "JSON", headers: headers) { (json) in
                    if json["data"].exists() {
                        UserDefaults.standard.set(true, forKey: "hasSignedIn")
                        if let name = json["data"]["name"].string, let email = json["data"]["email"].string, let api_token = json["data"]["api_token"].string, let user_id = json["data"]["id"].int {
                            UserDefaults.standard.set(name, forKey: "UserName")
                            UserDefaults.standard.set(email, forKey: "UserEmail")
                            UserDefaults.standard.set(api_token, forKey: "UserApiToken")
                            UserDefaults.standard.set(user_id, forKey: "UserId")
                            User.shared.createUser()
                            let alertController = UIAlertController(title: "", message: "User info updated!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                            self.reloadData()
                        }
                    } else {
                        let alertController = UIAlertController(title: "Oops", message: "Wrong credentials. Please try again!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func checkFields() -> Bool {
        return (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmPasswordTextField.text?.isEmpty)!
    }
    
    func checkPassword() -> Bool {
        return (passwordTextField.text) == (confirmPasswordTextField.text)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeUserInfoButtonTapped(_ sender: UIButton) {
        nameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        confirmPasswordTextField.isEnabled = true
        updateButton.isEnabled = true
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
