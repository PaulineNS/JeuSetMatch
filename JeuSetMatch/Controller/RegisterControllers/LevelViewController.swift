//
//  CityViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    
    var currentUser: User?

    var userLevel = ""
    var userCity = ""
    
    let levels: [String] = ["-30 - Pro","-15 - Pro","-4/6 - Pro","-2/6 - Pro","0 - Semi-pro","1/6 - Semi-pro","2/6 - Semi-pro","3/6 - Expert avancé","4/6 - Expert avancé","5/6 - Expert avancé","15 - Expert avancé","15/1 - Expert","15/2 - Expert","15/3 - Expert","15/4 - Compétiteur avancé","15/5 - Compétiteur avancé","30 - Compétiteur","30/1 - Compétiteur","30/2 - Intermédiaire avancé","30/3 - Intermédiaire","30/4 - Intermédiaire","30/5 - Amateur avancé","40 - Amateur","Débutant","Choisir"]
  
    @IBOutlet weak var citiesButton: UIButton!
    @IBOutlet weak var levelsPickerView: UIPickerView!
    @IBOutlet weak var cityAlertLabel: UILabel!
    @IBOutlet weak var levelAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsPickerView.delegate = self
        levelsPickerView.dataSource = self
        levelsPickerView.selectRow(levels.count-1, inComponent: 0, animated: true)
        cityAlertLabel.isHidden = true
        levelAlertLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.LeveltoCitiesSegue {
            guard let citiesVc = segue.destination as? CitiesViewController else { return }
            citiesVc.didSelectCityDelegate = self
        } else if segue.identifier == K.LeveltoPseudoSegue {
            guard let pseudoVc = segue.destination as? PseudoViewController else {return}
            pseudoVc.currentUser = User(pseudo: nil, image: nil, sexe: currentUser?.sexe, level: userLevel, city: userCity, birthDate: currentUser?.birthDate, uid: nil)
            
        }
    }
    
    @IBAction func citiesButtonSelected(_ sender: UIButton) {
        performSegue(withIdentifier: K.LeveltoCitiesSegue, sender: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
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
        performSegue(withIdentifier: K.LeveltoPseudoSegue, sender: nil)
    }    
}

extension LevelViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userLevel = levels[row]
    }
}

extension LevelViewController: DidSelectCityDelegate {
    func rowTapped(with city: String) {
        cityAlertLabel.isHidden = true
        citiesButton.setTitle(city, for: .normal)
        userCity = city
    }
}
