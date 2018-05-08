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
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let url = "http://127.0.0.1:8000/api/register"
            let parameters = ["name": nameTextField.text!, "email": emailTextField.text!, "password": passwordTextField.text!, "password_confirmation": passwordConfirmationTextField.text!]
            let headers = ["Accept": "application/json",
                           "Content-Type": "application/json"]
            APIConnect.shared.requestAPI(url: url, method: .post, parameters: parameters, encoding: "JSON", headers: headers) { (json) in
                if json["errors"].exists() {
                    var error = "Error:"
                    for (key, value) in json["errors"] {
                        error.append("\n- \(value[0].string!)")
                    }
                    let alertController = UIAlertController(title: "Oops", message: error, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "signupToMainSegue", sender: self)
                }
            }
        }
    }

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkFields() -> Bool {
        return (nameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (passwordConfirmationTextField.text?.isEmpty)!
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
