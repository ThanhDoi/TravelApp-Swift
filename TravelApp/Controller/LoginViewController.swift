//
//  LoginViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 4/27/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.cornerRadius = 10
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        loginButton.layer.cornerRadius = 10
        
        let signupStringPart1 = NSAttributedString(string: "Don't have an account? ", attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 18.0)!, NSAttributedStringKey.foregroundColor: UIColor.white])
        let signupStringPart2 = NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 18.0)!, NSAttributedStringKey.foregroundColor: UIColor.white])
        let signupString = NSMutableAttributedString()
        signupString.append(signupStringPart1)
        signupString.append(signupStringPart2)
        signupButton.setAttributedTitle(signupString, for: UIControlState.normal)
        
        FirstTimeRun.shared.getHotels()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if checkFields() {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            checkLogin()
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginToSignUpSegue", sender: self)
    }
    
    func checkFields() -> Bool {
        return (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!
    }
    
    func checkLogin() {
        let email = (emailTextField.text)!
        let password = (passwordTextField.text)!
        let url = "http://127.0.0.1:8000/api/login"
        let parameters = ["email": email, "password": password]
        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        
        APIConnect.shared.requestAPI(url: url, method: .post, parameters: parameters, encoding: "JSON", headers: headers) { json in
            if json["data"].exists() {
                UserDefaults.standard.set(true, forKey: "hasSignedIn")
                if let name = json["data"]["name"].string, let email = json["data"]["email"].string, let api_token = json["data"]["api_token"].string, let user_id = json["data"]["id"].int {
                    UserDefaults.standard.set(name, forKey: "UserName")
                    UserDefaults.standard.set(email, forKey: "UserEmail")
                    UserDefaults.standard.set(api_token, forKey: "UserApiToken")
                    UserDefaults.standard.set(user_id, forKey: "UserId")
                    User.shared.createUser()
                }
                self.performSegue(withIdentifier: "loginToMainSegue", sender: self)
            } else {
                let alertController = UIAlertController(title: "Oops", message: "Wrong credentials. Please try again!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "hasSignedIn") {
            User.shared.createUser()
            performSegue(withIdentifier: "loginToMainSegue", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        User.shared.destroy()
    }
}
