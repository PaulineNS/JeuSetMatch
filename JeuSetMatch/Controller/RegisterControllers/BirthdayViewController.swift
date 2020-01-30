//
//  PseudoViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class BirthdayViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var madamButton: UIButton!
    @IBOutlet private weak var sirButton: UIButton!
    @IBOutlet private weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet private weak var alertLabel: UILabel!
    
    // MARK: - Variables
    
    private var birthDate = Date()
    private var stringBirthDate = ""
    private var userGender = "Femme"
    private let minimumAge = Calendar.current.date(byAdding: .year, value: -10, to: Date())
    private let maximumAge = Calendar.current.date(byAdding: .year, value: -100, to: Date())
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true
        birthdayDatePicker.minimumDate = maximumAge
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDependingGender(madamColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirLabel: "◯ Monsieur", madamLabel: "⬤ Madame", gender: "Femme")
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.BirthDateSegue else {return}
        guard let levelVc = segue.destination as? LevelViewController else {return}
        levelVc.currentUser = UserObject(pseudo: nil, image: nil, sexe: userGender, level: nil, city: nil, birthDate: stringBirthDate, uid: nil)
    }
    
    // MARK: - Methods
    
    private func updateDependingGender(madamColor: UIColor, sirColor: UIColor, sirLabel: String, madamLabel: String, gender: String){
        madamButton.setTitle(madamLabel, for: .normal)
        sirButton.setTitle(sirLabel, for: .normal)
        madamButton.setTitleColor(madamColor, for: .normal)
        sirButton.setTitleColor(sirColor, for: .normal)
        userGender = gender
    }
    
    // MARK: - Actions
    
    @IBAction private func madamButtonSelected(_ sender: UIButton) {
        updateDependingGender(madamColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirLabel: "◯ Monsieur", madamLabel: "⬤ Madame", gender: "Femme")
    }
    
    @IBAction private func sirButtonSelected(_ sender: UIButton) {
        updateDependingGender(madamColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), sirColor: #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1), sirLabel: "⬤ Monsieur", madamLabel: "◯ Madame", gender: "Homme")
    }
    
    @IBAction private func birthDateChanged(_ sender: Any) {
        print(birthdayDatePicker.date)
        let isValideAge = validateAge(birthDate: birthdayDatePicker.date, minimumAge: minimumAge ?? Date())
        birthDate = birthdayDatePicker.date
        stringBirthDate = convertDateToString(date: birthDate)
        if isValideAge {
            alertLabel.isHidden = true
        } else {
            alertLabel.isHidden = false
            alertLabel.text = "Vous devez avoir au moins 10 ans pour utiliser l'application"
        }
    }
    
    @IBAction private func continueButtonPressed(_ sender: UIButton) {
        let isValideAge = validateAge(birthDate: birthDate, minimumAge: minimumAge ?? Date())
        guard isValideAge else {
            alertLabel.isHidden = false
            alertLabel.text = "Veuillez renseigner votre date de naissance avant de continuer"
            return}
        alertLabel.isHidden = true
        performSegue(withIdentifier: K.BirthDateSegue, sender: nil)
    }
}
