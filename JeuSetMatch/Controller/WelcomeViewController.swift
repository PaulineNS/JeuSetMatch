//
//  WelcomeViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 17/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        titleLabel.text = "🎾"
        var charIndex = 0.0
        let titleText = "Jeu Set & Match"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
                if self.titleLabel.text == "🎾Jeu Set & Match"{
                    self.registerButton.isHidden = false
                    self.logInButton.isHidden = false
                }
            }
            charIndex += 1
        }
    }
}
