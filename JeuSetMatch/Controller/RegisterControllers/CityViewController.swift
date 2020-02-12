//
//  CityViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class CityViewController: UIViewController {
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var userCity: String?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var citiesButton: UIButton!
    @IBOutlet private weak var levelsPickerView: UIPickerView!
    @IBOutlet private weak var cityAlertLabel: UILabel!
    @IBOutlet private weak var levelAlertLabel: UILabel!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        cityAlertLabel.isHidden = true
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.leveltoCitiesSegue {
            guard let citiesVc = segue.destination as? CitiesViewController else { return }
            citiesVc.didSelectCityDelegate = self
        } else if segue.identifier == Constants.Segue.cityToPicture {
            guard let pictureVc = segue.destination as? PictureViewController else {return}
            pictureVc.currentUser = UserObject(pseudo: nil, image: nil, sexe: currentUser?.sexe, level: currentUser?.level, city: userCity, birthDate: currentUser?.birthDate, uid: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func citiesButtonSelected(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.Segue.leveltoCitiesSegue, sender: nil)
    }
    
    @IBAction private func continueButtonPressed(_ sender: UIButton) {
        guard userCity != nil else {
            cityAlertLabel.isHidden = false
            cityAlertLabel.text = "Veuillez sélectionner votre ville avant de continuer"
            return }
        cityAlertLabel.isHidden = true
        performSegue(withIdentifier: Constants.Segue.cityToPicture, sender: nil)
    }    
}

// MARK: - DidSelectCityDelegate

extension CityViewController: DidSelectCityDelegate {
    func rowTapped(with city: String) {
        cityAlertLabel.isHidden = true
        citiesButton.setTitle(city, for: .normal)
        userCity = city
    }
}
