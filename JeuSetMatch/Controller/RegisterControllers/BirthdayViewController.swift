//
//  BirthdayViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

final class BirthdayViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet private weak var alertLbl: UILabel!
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var birthDate = Date()
    private var stringBirthDate: String?
    private let minimumAge = Calendar.current.date(byAdding: .year, value: -10, to: Date())
    private let maximumAge = Calendar.current.date(byAdding: .year, value: -100, to: Date())
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        alertLbl.isHidden = true
        birthdayDatePicker.minimumDate = maximumAge
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segue.birthDatetoLevel else {return}
        guard let levelVc = segue.destination as? LevelViewController else {return}
        levelVc.currentUser = UserObject(pseudo: nil, image: nil, sexe: currentUser?.sexe, level: nil, city: nil, birthDate: stringBirthDate, uid: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func birthDateChanged(_ sender: Any) {
        let isValideAge = validateAge(birthDate: birthdayDatePicker.date, minimumAge: minimumAge ?? Date())
        birthDate = birthdayDatePicker.date
        stringBirthDate = convertDateToString(date: birthDate)
        if isValideAge {
            alertLbl.isHidden = true
        } else {
            alertLbl.isHidden = false
            alertLbl.text = "Vous devez avoir au moins 10 ans pour utiliser l'application"
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        let isValideAge = validateAge(birthDate: birthDate, minimumAge: minimumAge ?? Date())
        guard isValideAge else {
            alertLbl.isHidden = false
            alertLbl.text = "Veuillez renseigner votre date de naissance avant de continuer"
            return}
        alertLbl.isHidden = true
        performSegue(withIdentifier: Constants.Segue.birthDatetoLevel, sender: nil)
    }
}
