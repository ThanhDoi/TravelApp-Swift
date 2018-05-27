//
//  LoginViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 4/27/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configLayouts()
    }
    
    func configLayouts() {
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
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if checkFields() {
            checkLogin()
        } else {
            let alertController = createAlertController(title: "Oops", mesage: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showSignUpSegue", sender: self)
    }
    
    func checkFields() -> Bool {
        return !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!
    }
    
    func checkLogin() {
        let email = (emailTextField.text)!
        let password = (passwordTextField.text)!
        APIConnect.shared.requestAPI(urlRequest: Router.login(email, password)) { (isSuccess, json) in
            if isSuccess {
                if json["data"].exists() {
                    UserDefaults.standard.set(true, forKey: "hasSignedIn")
                    if let name = json["data"]["name"].string, let email = json["data"]["email"].string, let api_token = json["data"]["api_token"].string, let user_id = json["data"]["id"].int {
                        UserDefaults.standard.set(name, forKey: "UserName")
                        UserDefaults.standard.set(email, forKey: "UserEmail")
                        UserDefaults.standard.set(api_token, forKey: "UserApiToken")
                        UserDefaults.standard.set(user_id, forKey: "UserId")
                        User.shared.createUser()
                    }
                    self.performSegue(withIdentifier: "showMainSegue", sender: self)
                } else {
                    let alertController = createAlertController(title: "Oops", mesage: "Wrong credentials. Please try again!")
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                let alertController = createAlertController(title: "Oops", mesage: "Something went wrong. Please try again!")
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RunFirst.shared.checkConnection { (isSuccess) in
            if isSuccess {
                if UserDefaults.standard.bool(forKey: "hasSignedIn") {
                    User.shared.createUser()
                    self.performSegue(withIdentifier: "showMainSegue", sender: nil)
                }
            } else {
                let alertController = createAlertController(title: "Oops", mesage: "Cannot connect to server. Please try again later!")
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        User.shared.destroy()
    }
}
