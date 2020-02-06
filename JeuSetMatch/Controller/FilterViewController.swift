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
        guard let gender = UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterGender), let city = UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterCity), let level = UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterLevel) else {return}
        switch gender {
        case gender where gender == "Tout" && city == "Tout" && level == "Tout":
            fetchUsersWithoutFilters()
        case gender where gender == "Tout" && city == "Tout" && level != "Tout":
            let levelField = Constants.FStore.userLevelField
            fetchUsersWithOneFilter(field1: levelField, field1value: level)
        case gender where gender == "Tout" && city != "Tout" && level == "Tout":
            let cityField = Constants.FStore.userCityField
            fetchUsersWithOneFilter(field1: cityField, field1value: city)
        case gender where gender != "Tout" && city == "Tout" && level == "Tout":
            let genderField = Constants.FStore.userGenderField
            fetchUsersWithOneFilter(field1: genderField, field1value: gender)
        case gender where gender != "Tout" && city != "Tout" && level == "Tout":
            let cityField = Constants.FStore.userCityField
            let genderField = Constants.FStore.userGenderField
            fetchUsersWithTwoFilters(field1: genderField, field1value: gender, field2: cityField, field2Value: city)
        case gender where gender != "Tout" && city == "Tout" && level != "Tout":
            let genderField = Constants.FStore.userGenderField
            let levelField = Constants.FStore.userLevelField
            fetchUsersWithTwoFilters(field1: genderField, field1value: gender, field2: levelField, field2Value: level)
        case gender where gender == "Tout" && city != "Tout" && level != "Tout":
            let cityField = Constants.FStore.userCityField
            let genderField = Constants.FStore.userGenderField
            fetchUsersWithTwoFilters(field1: cityField, field1value: city, field2: genderField, field2Value: gender)
        case gender where gender != "Tout" && city != "Tout" && level != "Tout":
            fetchUsersWithThreeFilters(gender: gender, city: city, level: level)
        default:
            break
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
    
    func fetchUsersWithOneFilter(field1: String, field1value: String){
        fetchUsersDependingOneFilter(field1: field1, field1value: field1value, onSuccess: {(users) in
            self.userFound.append(users)
            self.popViewController()
        }, onNone: {
            self.userFound = []
            self.popViewController()
        })
    }
    
    func fetchUsersWithTwoFilters(field1: String, field1value: String, field2: String, field2Value: String){
        fetchUsersDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, onSuccess: {(users) in
            self.userFound.append(users)
            self.didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
            self.navigationController?.popViewController(animated: true)
        }, onNone: {
            self.userFound = []
            self.popViewController()
        })
    }
    
    func fetchUsersWithThreeFilters(gender: String, city: String, level: String) {
        fetchUsersDependingThreeFilters(gender: gender, city: city, level: level, onSuccess: {(users) in
            self.userFound.append(users)
            self.popViewController()
        }, onNone: {
            self.userFound = []
            self.popViewController()
        })
    }
    
    func fetchUsersWithoutFilters(){
        fetchUsersWithoutFilters(onSuccess: { (users) in
            self.userFound.append(users)
            self.popViewController()
        }, onNone: {
            self.userFound = []
            self.popViewController()
        })
    }
    
    func popViewController() {
        didSearchFiltersDelegate?.searchFiltersTapped(users: self.userFound)
        navigationController?.popViewController(animated: true)
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
        switch indexPath.row {
        case indexPath.row where indexPath.row == 0:
        if UserDefaults.standard.object(forKey: "savedAge") != nil {
            cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: "savedAge")
        }
        cell.filterValueTxtField.inputView = cell.agePicker
        case indexPath.row where indexPath.row == 1:
            if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterLevel) != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterLevel)
            }
            cell.filterValueTxtField.inputView = cell.levelPicker
        case indexPath.row where indexPath.row == 2:
            if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterGender) != nil {
                cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterGender)
            }
            cell.filterValueTxtField.inputView = cell.genderPicker
        case indexPath.row where indexPath.row == 3:
        if UserDefaults.standard.object(forKey: Constants.UDefault.savedFilterCity) != nil {
            cell.filterValueTxtField.text =  UserDefaults.standard.string(forKey: Constants.UDefault.savedFilterCity)
        }
        cell.filterValueTxtField.isEnabled = false
        default:
            break
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
