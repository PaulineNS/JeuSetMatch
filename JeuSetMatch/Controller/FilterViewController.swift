//
//  FilterViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 15/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

final class FilterViewController: UIViewController {
    
    // MARK: - Instensiation
    
    private let firestoreUser = FirestoreUserService()
    private let customLoader = CustomLoader()

    // MARK: - Variables
    
    var didSearchFiltersDelegate: DidSearchFiltersDelegate?
    lazy private var userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
    private let filtersDictionnary = ["Age": "Tout", "Niveau": "Tout", "Sexe": "Tout", "Ville": "Tout"]
    private var filtersArray = [Filters]()
    private var citySelected: String?
    private var userFound: [UserObject] = []
    
    // MARK: - Outlets

    @IBOutlet weak var filterTableView: UITableView!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.register(UINib(nibName: Constants.Cell.filterCellNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.filterCellIdentifier)
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
    
    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.filterToCitiesSegue {
            guard let citiesVc = segue.destination as? CitiesViewController else { return }
            citiesVc.didSelectCityDelegate = self
        }
    }
    
    // MARK: - Actions

    @IBAction func searchPlayers(_ sender: Any) {
        
        // MARK: - TODO ENUM
        
        guard let gender = UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterGender), let city = UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterCity), let level = UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterLevel) else {return}
        //Three filters
        if gender == "Tout" && city == "Tout" && level == "Tout" {
            fetchUsersWithoutFilters()
        }
        //One Filters
        if gender == "Tout" && city == "Tout" && level != "Tout" {
            let levelField = Constants.FStore.userLevelField
            fetchUsersDependingOneFilter(field1: levelField, field1value: level)
        }
        if gender == "Tout" && city != "Tout" && level == "Tout" {
            let cityField = Constants.FStore.userCityField
            fetchUsersDependingOneFilter(field1: cityField, field1value: city)
        }
        if gender != "Tout" && city == "Tout" && level == "Tout" {
            let genderField = Constants.FStore.userGenderField
            fetchUsersDependingOneFilter(field1: genderField, field1value: gender)
        }
        // TwoFilters
        if gender != "Tout" && city != "Tout" && level == "Tout" {
            let cityField = Constants.FStore.userCityField
            let genderField = Constants.FStore.userGenderField
            fetchUsersDependingTwoFilters(field1: genderField, field1value: gender, field2: cityField, field2Value: city)
        }
        if gender != "Tout" && city == "Tout" && level != "Tout" {
            let genderField = Constants.FStore.userGenderField
            let levelField = Constants.FStore.userLevelField
            fetchUsersDependingTwoFilters(field1: genderField, field1value: gender, field2: levelField, field2Value: level)
        }
        if gender == "Tout" && city != "Tout" && level != "Tout" {
            let cityField = Constants.FStore.userCityField
            let levelField = Constants.FStore.userLevelField
            fetchUsersDependingTwoFilters(field1: cityField, field1value: city, field2: levelField, field2Value: level)
        }
        // Without Filters
        if gender != "Tout" && city != "Tout" && level != "Tout" {
            fetchUsersDependingThreeFilters(gender: gender, city: city, level: level)
        }
    }
    
    @IBAction func canceledFilters(_ sender: Any) {
        let newFilterValue = "Tout"
        deleteAllUserDefaultData(filterValue: newFilterValue)
        filtersArray = []
        for (key, value) in filtersDictionnary.sorted(by: { $0.0 < $1.0 }) {
            filtersArray.append(Filters(denomination: key, value: value))
        }
        filterTableView.reloadData()
    }
    
    // MARK: - Methods

    func fetchUsersDependingOneFilter(field1: String, field1value: String){
        customLoader.showLoaderView()
        userUseCase.fetchUserInformationsDependingOneFilter(field1: field1, field1value: field1value, completion: { (result) in
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
        userUseCase.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: { (result) in
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
        userUseCase.fetchUserInformationsDependingAllFilters(gender: gender, city: city, level: level, completion: { (result) in
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
        userUseCase.fetchUserWithoutFilters(completion: { (result) in
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

    func deleteAllUserDefaultData(filterValue: String) {
        UserDefaults.standard.set(filterValue, forKey: Constants.UDefault.savedFilterCity)
        UserDefaults.standard.set(filterValue, forKey: Constants.UDefault.savedFilterLevel)
        UserDefaults.standard.set(filterValue, forKey: Constants.UDefault.savedFilterGender)
    }
}

// MARK: - TableView Delegate and DataSource

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.filterCellIdentifier, for: indexPath) as? FilterTableViewCell else {return UITableViewCell()}
        
        cell.filter = filtersArray[indexPath.row]
        
        if indexPath.row == 1 {
            if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterLevel) != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterLevel)
            }
            cell.filterValueTxtField.inputView = cell.levelPicker
        }
        if indexPath.row == 2 {
            if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterGender) != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterGender)
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
            if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterCity) != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterCity)
            }
            cell.filterValueTxtField.isEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.filterToCitiesSegue, sender: nil)
    }
}

// MARK: - DidSelectCityDelegate

extension FilterViewController: DidSelectCityDelegate {
    func rowTapped(with city: String) {
        citySelected = city
        UserDefaults.standard.set(city, forKey: Constants.UDefault.savedFilterCity)
    }
}


