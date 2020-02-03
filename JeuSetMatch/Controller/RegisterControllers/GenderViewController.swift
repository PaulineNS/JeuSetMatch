//
//  PseudoViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class GenderViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var madamButton: UIButton!
    @IBOutlet weak var sirButton: UIButton!
    
    // MARK: - Variables
    
    private var userGender: String?

    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        alertLabel.isHidden = true
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "GenderToBirthDate" else {return}
        guard let birthdateVc = segue.destination as? BirthdayViewController else {return}
        birthdateVc.currentUser = UserObject(pseudo: nil, image: nil, sexe: userGender, level: nil, city: nil, birthDate: nil, uid: nil)
    }
    
    // MARK: - Actions
    @IBAction func madamCheckboxTapped(_ sender: UIButton) {
            madamButton.isSelected = true
            sirButton.isSelected = false
        }
    
    @IBAction func sirCheckboxTapped(_ sender: UIButton) {
            sirButton.isSelected = true
            madamButton.isSelected = false
    }
    
    @IBAction private func continueButtonPressed(_ sender: UIButton) {
        if madamButton.isSelected {
            userGender = "Femme"

        }
        if sirButton.isSelected {
            userGender = "Homme"
        }
        guard userGender != nil else {
            print("met un gender")
//            pseudoAlert.isHidden = false
//            pseudoAlert.text = "Veuillez renseigner un pseudo avant de continuer"
            return
        }
        print(userGender)

//        pseudoAlert.isHidden = true
        performSegue(withIdentifier: "GenderToBirthDate", sender: nil)
    }
}
