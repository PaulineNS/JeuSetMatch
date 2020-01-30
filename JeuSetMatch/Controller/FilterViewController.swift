//
//  FilterViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 15/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    private let filtersDictionnary = ["Age": "Tout", "Niveau": "Tout", "Sexe": "Tout", "Ville": "Tout"]
    private var filtersArray = [Filters]()
    var citySelected = ""
    var userUseCase: UserUseCase?
    private var userFound: [UserObject] = []
    var didSearchFiltersDelegate: DidSearchFiltersDelegate?
    let customLoader = CustomLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firestoreUser = FirestoreUserService()
        self.userUseCase = UserUseCase(user: firestoreUser)
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
        
        guard let gender = UserDefaults.standard.string(forKey: "savedGender"), let city = UserDefaults.standard.string(forKey: "savedCity"), let level = UserDefaults.standard.string(forKey: "savedLevel") else {return}
        //Three filters
        if gender == "Tout" && city == "Tout" && level == "Tout" {
            fetchUsersWithoutFilters()
        }
        //One Filters
        if gender == "Tout" && city == "Tout" && level != "Tout" {
            let levelField = "userLevel"
            fetchUsersDependingOneFilter(field1: levelField, field1value: level)
        }
        if gender == "Tout" && city != "Tout" && level == "Tout" {
            let cityField = "userCity"
            fetchUsersDependingOneFilter(field1: cityField, field1value: city)
        }
        if gender != "Tout" && city == "Tout" && level == "Tout" {
            let genderField = "userGender"
            fetchUsersDependingOneFilter(field1: genderField, field1value: gender)
        }
        // TwoFilters
        if gender != "Tout" && city != "Tout" && level == "Tout" {
            let cityField = "userCity"
            let genderField = "userGender"
            fetchUsersDependingTwoFilters(field1: genderField, field1value: gender, field2: cityField, field2Value: city)
        }
        if gender != "Tout" && city == "Tout" && level != "Tout" {
            let genderField = "userGender"
            let levelField = "userLevel"
            fetchUsersDependingTwoFilters(field1: genderField, field1value: gender, field2: levelField, field2Value: level)
        }
        if gender == "Tout" && city != "Tout" && level != "Tout" {
            let cityField = "userCity"
            let genderField = "userGender"
            fetchUsersDependingTwoFilters(field1: cityField, field1value: city, field2: genderField, field2Value: gender)
        }
        // Without Filters
        if gender != "Tout" && city != "Tout" && level != "Tout" {
            fetchUsersDependingThreeFilters(gender: gender, city: city, level: level)
        }
    }
    
    func fetchUsersDependingOneFilter(field1: String, field1value: String){
        customLoader.showLoaderView()
        userUseCase?.fetchUserInformationsDependingOneFilter(field1: field1, field1value: field1value, completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.userFound.append(users)
                self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                self.userFound = []
                self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func fetchUsersDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String){
        customLoader.showLoaderView()
        userUseCase?.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: { (result) in
        self.customLoader.hideLoaderView()
        switch result {
        case .success(let users):
            self.userFound.append(users)
            self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
            self.navigationController?.popViewController(animated: true)
        case .failure(let error):
            print(error.localizedDescription)
        case .none:
                            self.userFound = []
            self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
            self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func fetchUsersDependingThreeFilters(gender: String, city: String, level: String) {
        customLoader.showLoaderView()
        userUseCase?.fetchUserInformationsDependingAllFilters(gender: gender, city: city, level: level, completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.userFound.append(users)
                self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                                self.userFound = []
                self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func fetchUsersWithoutFilters(){
        customLoader.showLoaderView()
        userUseCase?.fetchUserWithoutFilters(completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.userFound.append(users)
                self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                                self.userFound = []
                self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }

    @IBAction func canceledFilters(_ sender: Any) {
        deleteAllUserDefaultData()
        filtersArray = []
        for (key, value) in filtersDictionnary.sorted(by: { $0.0 < $1.0 }) {
            filtersArray.append(Filters(denomination: key, value: value))
        }
        filterTableView.reloadData()
    }
    
    func deleteAllUserDefaultData() {
        UserDefaults.standard.set("Tout", forKey: "savedCity")
        UserDefaults.standard.set("Tout", forKey: "savedLevel")
        UserDefaults.standard.set("Tout", forKey: "savedGender")
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


