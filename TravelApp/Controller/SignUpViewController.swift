//
//  SignUpViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 4/28/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmationTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configLayouts()
    }
    
    func configLayouts() {
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.white.cgColor
        nameTextField.layer.cornerRadius = 10
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.cornerRadius = 10
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordConfirmationTextField.layer.borderWidth = 1
        passwordConfirmationTextField.layer.borderColor = UIColor.white.cgColor
        passwordConfirmationTextField.layer.cornerRadius = 10
        passwordConfirmationTextField.attributedPlaceholder = NSAttributedString(string: "Password Confirmation", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.cornerRadius = 10
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if checkFields() {
            APIConnect.shared.requestAPI(urlRequest: Router.signup(nameTextField.text!, emailTextField.text!, passwordTextField.text!, passwordConfirmationTextField.text!)) { (isSuccess, json) in
                if isSuccess {
                    if json["errors"].exists() {
                        var error = "Error:"
                        for (_, value) in json["errors"] {
                            error.append("\n- \(value[0].string!)")
                        }
                        let alertController = createAlertController(title: "Oops", mesage: error)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        UserDefaults.standard.set(true, forKey: "hasSignedIn")
                        if let name = json["data"]["name"].string, let email = json["data"]["email"].string, let api_token = json["data"]["api_token"].string, let user_id = json["data"]["id"].int {
                            UserDefaults.standard.set(name, forKey: "UserName")
                            UserDefaults.standard.set(email, forKey: "UserEmail")
                            UserDefaults.standard.set(api_token, forKey: "UserApiToken")
                            UserDefaults.standard.set(user_id, forKey: "UserId")
                            User.shared.createUser()
                        }
                        let alertController = UIAlertController(title: "Done", message: "Your account has been created successfully and is ready to use!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                            self.performSegue(withIdentifier: "signupToMainSegue", sender: self)
                        })
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    let alertController = createAlertController(title: "Oops", mesage: "Something went wrong. Please try again!")
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            let alertController = createAlertController(title: "Oops", mesage: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkFields() -> Bool {
        return !(nameTextField.text?.isEmpty)! && !(emailTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)! && !(passwordConfirmationTextField.text?.isEmpty)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
