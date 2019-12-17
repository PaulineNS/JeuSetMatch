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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "🎾 Jeu Set & Match 🎾"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        /// performsegue
    }

}
