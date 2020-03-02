//
//  LevelViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

final class LevelViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var levelPickerView: UIPickerView!
    @IBOutlet private weak var levelAlert: UILabel!
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var userLevel: String?
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        levelPickerView.selectRow(Constants.Arrays.levelsPickerRegister.count-1, inComponent: 0, animated: true)
        levelAlert.isHidden = true
    }
    
    // MARK: - Segue
    
    ///Prepare segue to cityVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.levelToCity {
            guard let cityVc = segue.destination as? CityViewController else {return}
            cityVc.currentUser = UserObject(pseudo: nil, image: nil, sexe: currentUser?.sexe, level: userLevel, city: nil, birthDate: currentUser?.birthDate, uid: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func continueButtonPressed(_ sender: Any) {
        guard userLevel != nil && userLevel != "Choisir" else {
            levelAlert.isHidden = false
            levelAlert.text = "Veuillez renseigner votre niveau avant de continuer"
            return}
        levelAlert.isHidden = true
        performSegue(withIdentifier: Constants.Segue.levelToCity, sender: nil)
    }
}

// MARK: - PickerView Delegate, Datasource

extension LevelViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    ///Number of component in the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    ///Number of rows in the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.Arrays.levelsPickerRegister.count
    }
    
    ///rowt title in the pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.Arrays.levelsPickerRegister[row]
    }
    
    ///Actioin after selecting a row in  the pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userLevel = Constants.Arrays.levelsPickerRegister[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Constants.Arrays.levelsPickerRegister[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}
