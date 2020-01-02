//
//  PseudoViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {

    @IBOutlet weak var madamButton: UIButton!
    @IBOutlet weak var sirButton: UIButton!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    var birthDate = Date()
    var userGender = "Madam"
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDependingGender(madamColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirLabel: "◯ Monsieur", madamLabel: "⬤ Madame", gender: "Madam")
    }
    
    func updateDependingGender(madamColor: UIColor, sirColor: UIColor, sirLabel: String, madamLabel: String, gender: String){
        madamButton.setTitle(madamLabel, for: .normal)
        sirButton.setTitle(sirLabel, for: .normal)
        madamButton.setTitleColor(madamColor, for: .normal)
        sirButton.setTitleColor(sirColor, for: .normal)
        userGender = gender
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.BirthDateSegue else {return}
        guard let cityVc = segue.destination as? LevelViewController else {return}
        cityVc.birthDate = birthDate
        cityVc.userGender = userGender
    }
    
    @IBAction func madamButtonSelected(_ sender: UIButton) {
        updateDependingGender(madamColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirLabel: "◯ Monsieur", madamLabel: "⬤ Madame", gender: "Madam")
    }
    
    @IBAction func sirButtonSelected(_ sender: UIButton) {
        updateDependingGender(madamColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirLabel: "⬤ Monsieur", madamLabel: "◯ Madame", gender: "Sir")
    }
    
    @IBAction func birthDateChanged(_ sender: Any) {
        print(birthdayDatePicker.date)
        birthDate = birthdayDatePicker.date
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.BirthDateSegue, sender: nil)
    }
    
}


// Check Age
