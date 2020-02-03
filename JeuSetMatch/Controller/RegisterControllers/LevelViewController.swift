//
//  CityViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class LevelViewController: UIViewController {
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var userLevel: String?
    private var userCity: String?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var citiesButton: UIButton!
    @IBOutlet private weak var levelsPickerView: UIPickerView!
    @IBOutlet private weak var cityAlertLabel: UILabel!
    @IBOutlet private weak var levelAlertLabel: UILabel!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsPickerView.selectRow(Constants.Arrays.levelsPickerRegister.count-1, inComponent: 0, animated: true)
        cityAlertLabel.isHidden = true
        levelAlertLabel.isHidden = true
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.leveltoCitiesSegue {
            guard let citiesVc = segue.destination as? CitiesViewController else { return }
            citiesVc.didSelectCityDelegate = self
        } else if segue.identifier == Constants.Segue.leveltoPseudoSegue {
            guard let pseudoVc = segue.destination as? PseudoViewController else {return}
            pseudoVc.currentUser = UserObject(pseudo: nil, image: nil, sexe: currentUser?.sexe, level: userLevel, city: userCity, birthDate: currentUser?.birthDate, uid: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func citiesButtonSelected(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segue.leveltoCitiesSegue, sender: nil)
    }
    
    @IBAction private func continueButtonPressed(_ sender: UIButton) {
        guard userCity != "" else {
            cityAlertLabel.isHidden = false
            cityAlertLabel.text = "Veuillez sélectionner votre ville avant de continuer"
            return }
        guard userLevel != "" && userLevel != "Choisir" else {
            levelAlertLabel.isHidden = false
            levelAlertLabel.text = "Veuillez renseigner votre niveau avant de continuer"
            return}
        cityAlertLabel.isHidden = true
        levelAlertLabel.isHidden = true
        performSegue(withIdentifier: Constants.Segue.leveltoPseudoSegue, sender: nil)
    }    
}

// MARK: - PickerView

extension LevelViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.Arrays.levelsPickerRegister.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.Arrays.levelsPickerRegister[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userLevel = Constants.Arrays.levelsPickerRegister[row]
    }
}

extension LevelViewController: DidSelectCityDelegate {
    func rowTapped(with city: String) {
        cityAlertLabel.isHidden = true
        citiesButton.setTitle(city, for: .normal)
        userCity = city
    }
}
