//
//  WelcomeViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 17/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    
    // MARK: - Controller life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateTheTitle()
    }
    
    // MARK: - Methods
    
    private func animateTheTitle() {
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = K.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
                if self.titleLabel.text == K.appName {
                    self.registerButton.isHidden = false
                    self.logInButton.isHidden = false
                }
            }
            charIndex += 1
        }
    }
}
