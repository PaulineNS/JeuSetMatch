//
//  LevelViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {

    @IBOutlet weak var levelPickerView: UIPickerView!
    @IBOutlet weak var levelAlert: UILabel!
    
    var currentUser: UserObject?
    private var userLevel: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    levelPickerView.selectRow(Constants.Arrays.levelsPickerRegister.count-1, inComponent: 0, animated: true)
        levelAlert.isHidden = true
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.levelToCity {
            guard let cityVc = segue.destination as? CityViewController else {return}
            cityVc.currentUser = UserObject(pseudo: nil, image: nil, sexe: currentUser?.sexe, level: userLevel, city: nil, birthDate: currentUser?.birthDate, uid: nil)
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        guard userLevel != nil && userLevel != "Choisir" else {
            levelAlert.isHidden = false
            levelAlert.text = "Veuillez renseigner votre niveau avant de continuer"
            return}
        levelAlert.isHidden = true
        performSegue(withIdentifier: Constants.Segue.levelToCity, sender: nil)
    }
}

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
