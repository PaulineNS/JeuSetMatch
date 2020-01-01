//
//  PseudoViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

class PseudoViewController: UIViewController {
    
    var birthDate = Date()
    var userGender = ""
    var userLevel = ""
    var userCity = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print(birthDate)
        print(userGender)
        print(userLevel)
        print(userCity)
    }
}
