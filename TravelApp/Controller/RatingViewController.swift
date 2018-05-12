//
//  RatingViewController.swift
//  TravelApp
//
//  Created by Thanh Doi on 5/8/18.
//  Copyright © 2018 Thanh Doi. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    @IBOutlet var ratingControl: RatingControl!
    var isWrong = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isWrong {
            let alertController = UIAlertController(title: "Oops", message: "Something went wrong. Please try again!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
                self.performSegue(withIdentifier: "unwindToDetailSegue", sender: self)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
