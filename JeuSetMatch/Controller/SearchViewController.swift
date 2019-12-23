//
//  SearchViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 21/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
}
