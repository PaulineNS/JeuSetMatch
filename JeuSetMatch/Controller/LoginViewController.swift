//
//  LoginViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 19/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true

    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                self.alertLabel.isHidden = false
                self.alertLabel.text = e.localizedDescription
            } else {
                self.performSegue(withIdentifier: "FromLoginToSearch", sender: self)
            }
        }
    }
}
