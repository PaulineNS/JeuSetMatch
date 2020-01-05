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
    @IBOutlet weak var alertLabel: UILabel!
    
    var birthDate = Date()
    var stringBirthDate = ""
    var userGender = "Femme"
    
    let minimumAge = Calendar.current.date(byAdding: .year, value: -10, to: Date())
    let maximumAge = Calendar.current.date(byAdding: .year, value: -100, to: Date())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true
        birthdayDatePicker.minimumDate = maximumAge
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDependingGender(madamColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirLabel: "◯ Monsieur", madamLabel: "⬤ Madame", gender: "Femme")
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
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
        cityVc.birthDate =  stringBirthDate
        cityVc.userGender = userGender
    }
    
    @IBAction func madamButtonSelected(_ sender: UIButton) {
        updateDependingGender(madamColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirLabel: "◯ Monsieur", madamLabel: "⬤ Madame", gender: "Femme")
    }
    
    @IBAction func sirButtonSelected(_ sender: UIButton) {
        updateDependingGender(madamColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirLabel: "⬤ Monsieur", madamLabel: "◯ Madame", gender: "Homme")
    }
    
    @IBAction func birthDateChanged(_ sender: Any) {
        print(birthdayDatePicker.date)
        let isValideAge = validateAge(birthDate: birthdayDatePicker.date)
        birthDate = birthdayDatePicker.date
        stringBirthDate = convertDateToString(date: birthDate)
        if isValideAge {
            alertLabel.isHidden = true
        } else {
            alertLabel.isHidden = false
            alertLabel.text = "Vous devez avoir au moins 10 ans pour utiliser l'application"
        }
    }
    
    func validateAge(birthDate: Date) -> Bool {
        var isValid: Bool = true
        
        if birthDate > minimumAge ?? Date() {
            isValid = false
        }
        
        return isValid
    }

    @IBAction func continueButtonPressed(_ sender: UIButton) {
        let isValideAge = validateAge(birthDate: birthDate)
        guard isValideAge else {
            alertLabel.isHidden = false
            alertLabel.text = "Veuillez renseigner votre date de naissance avant de continuer"
            return}
        alertLabel.isHidden = true
        performSegue(withIdentifier: K.BirthDateSegue, sender: nil)
    }
    
}


