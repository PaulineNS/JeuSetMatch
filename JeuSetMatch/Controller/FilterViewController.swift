//
//  FilterViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 15/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

protocol DidSearchFiltersDelegate {
    func searchFiltersTapped(users: [UserObject])
}


class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    private let filtersDictionnary = ["Age": "Tout", "Niveau": "Tout", "Sexe": "Tout", "Ville": "Tout"]
    private var filtersArray = [Filters]()
    var citySelected = ""
    var userUseCase: UserUseCase?
    private var userFound: [UserObject] = []
    var didSearchFiltersDelegate: DidSearchFiltersDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firestoreUser = FirestoreUserService()
        self.userUseCase = UserUseCase(user: firestoreUser)
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.register(UINib(nibName: K.filterCellNibName, bundle: nil), forCellReuseIdentifier: K.filterCellIdentifier)
        for (key, value) in filtersDictionnary.sorted(by: { $0.0 < $1.0 }) {
            filtersArray.append(Filters(denomination: key, value: value))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if citySelected != "" {
            filtersArray[3].value = citySelected
        }
        
        filterTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterToCities" {
            guard let citiesVc = segue.destination as? CitiesViewController else { return }
            citiesVc.didSelectCityDelegate = self
        }
    }
    
    @IBAction func searchPlayers(_ sender: Any) {
        let gender = "Homme"
        let city = "Nantes, France"
        let level = "30/3 - Intermédiaire"
        userUseCase?.fetchUserInformationsDependingFilters(gender: gender, city: city, level: level, completion: { (result) in
            switch result {
            case .success(let users):
                self.userFound.append(users)
                self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.filterCellIdentifier, for: indexPath) as? FilterTableViewCell else {return UITableViewCell()}
        
        cell.filter = filtersArray[indexPath.row]
        
        if indexPath.row == 1 {
            if UserDefaults.standard.object(forKey: "savedLevel") != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: "savedLevel")
            }
            cell.filterValueTxtField.inputView = cell.levelPicker
        }
        if indexPath.row == 2 {
            if UserDefaults.standard.object(forKey: "savedGender") != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: "savedGender")
            }
            cell.filterValueTxtField.inputView = cell.genderPicker
        }
        if indexPath.row == 0 {
            if UserDefaults.standard.object(forKey: "savedAge") != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: "savedAge")
            }
            cell.filterValueTxtField.inputView = cell.agePicker
        }
        if indexPath.row == 3 {
            if UserDefaults.standard.object(forKey: "savedCity") != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: "savedCity")
            }
            cell.filterValueTxtField.isEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "FilterToCities", sender: nil)
        }
}

extension FilterViewController: DidSelectCityDelegate {
    func rowTapped(with city: String) {
        citySelected = city
        UserDefaults.standard.set(city, forKey: "savedCity")
    }
}


