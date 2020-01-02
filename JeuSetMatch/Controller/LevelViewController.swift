//
//  CityViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {

    var birthDate = Date()
    var userGender = ""
    var userLevel = ""
    var userCity = ""
    let cities: [String] = ["Choisir", "Débutant","40 - Amateur","30/5 - Amateur avancé","30/4 - Intermédiaire","30/3 - Intermédiaire","30/2 - Intermédiaire avancé","30/1 - Compétiteur","30 - Compétiteur","15/5 - Compétiteur avancé","15/4 - Compétiteur avancé","15/3 - Expert","15/2 - Expert","15/1 - Expert","15 - Expert avancé","5/6 - Expert avancé","4/6 - Expert avancé","3/6 - Expert avancé","2/6 - Semi-pro","1/6 - Semi-pro","0 - Semi-pro","-2/6 - Pro","-4/6 - Pro","-15 - Pro", "-30 - Pro"]
  
    @IBOutlet weak var citiesButton: UIButton!
    @IBOutlet weak var levelsPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsPickerView.delegate = self
        levelsPickerView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.LeveltoCitiesSegue {
            guard let citiesVc = segue.destination as? CitiesViewController else { return }
            citiesVc.didSelectCityDelegate = self
        } else if segue.identifier == K.LeveltoPseudoSegue {
            guard let pseudoVc = segue.destination as? PseudoViewController else {return}
            pseudoVc.birthDate = birthDate
            pseudoVc.userGender = userGender
            pseudoVc.userLevel = userLevel
            pseudoVc.userCity = userCity
        }
    }
    
    @IBAction func citiesButtonSelected(_ sender: UIButton) {
        performSegue(withIdentifier: K.LeveltoCitiesSegue, sender: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.LeveltoPseudoSegue, sender: nil)
    }    
}

extension LevelViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userLevel = cities[row]
    }
}

extension LevelViewController: DidSelectCityDelegate {
    func rowTapped(with city: String) {
        citiesButton.setTitle(city, for: .normal)
        userCity = city
    }
}
