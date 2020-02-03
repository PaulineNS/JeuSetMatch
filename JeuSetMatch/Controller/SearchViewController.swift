//
//  UsersViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    // MARK: - Instensiation
    
    private let customLoader = CustomLoader()
    private let firestoreUser = FirestoreUserService()
    
    // MARK: - Variables
    
    var userSelected: UserObject?
    lazy private var userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
    private var users: [UserObject] = []
    
    // MARK: - Outlets
    
    @IBOutlet private weak var usersTableView: UITableView! { didSet { usersTableView.tableFooterView = UIView() }}
    @IBOutlet private weak var filterBarButton: UIBarButtonItem!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        usersTableView.register(UINib(nibName: Constants.Cell.userCellNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.userCellIdentifier)
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Joueurs"
        self.tabBarController?.navigationItem.rightBarButtonItem = filterBarButton
        usersTableView.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.searchToProfileSegue {
            guard let profileVc = segue.destination as? ProfileViewController else {return}
            profileVc.navigationItem.rightBarButtonItem = nil
            profileVc.userToShow = userSelected
            profileVc.IsSegueFromSearch = true
        }
        if segue.identifier == Constants.Segue.searchToFilterSegue {
            guard let filterVc = segue.destination as? FilterViewController else {return}
            filterVc.didSearchFiltersDelegate = self
        }
    }
    
    // MARK: - Actions

    @IBAction private func didTapFilterButton(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segue.searchToFilterSegue, sender: nil)
    }
    
    // MARK: - Methods
    
    func fetchUsers(){
        
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
            let genderField = Constants.FStore.userGenderField
            fetchUsersDependingTwoFilters(field1: cityField, field1value: city, field2: genderField, field2Value: gender)
        }
        // Without Filters
        if gender != "Tout" && city != "Tout" && level != "Tout" {
            fetchUsersDependingThreeFilters(gender: gender, city: city, level: level)
        }
    }
    
    func fetchUsersDependingOneFilter(field1: String, field1value: String){
        customLoader.showLoaderView()
        userUseCase.fetchUserInformationsDependingOneFilter(field1: field1, field1value: field1value, completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.users.append(users)
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                self.users = []
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            }
        })
    }
    
    func fetchUsersDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String){
        customLoader.showLoaderView()
        userUseCase.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.users.append(users)
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            }
        })
    }
    
    func fetchUsersDependingThreeFilters(gender: String, city: String, level: String) {
        customLoader.showLoaderView()
        userUseCase.fetchUserInformationsDependingAllFilters(gender: gender, city: city, level: level, completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.users.append(users)
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                DispatchQueue.main.async {
                    
                    self.usersTableView.reloadData()
                }
            }
        })
    }
    
    func fetchUsersWithoutFilters(){
        customLoader.showLoaderView()
        userUseCase.fetchUserWithoutFilters(completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.users.append(users)
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            }
        })
    }
}

// MARK: - TableView DataSource

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.userCellIdentifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell()}
        cell.userName.text = user.pseudo
        cell.userImage.image = UIImage(data: user.image ?? Data())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.userSelected = user
        performSegue(withIdentifier: Constants.Segue.searchToProfileSegue, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "person")
        view.addSubview(imageView)
        
        let label = UILabel()
        label.text = "Aucun joueur ne correspond à votre recherche"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        view.addSubview(label)

        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.width.equalTo(200)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20.0)
            make.right.equalTo(view).offset(15.0)
            make.left.equalTo(view).offset(15.0)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return users.isEmpty ? tableView.bounds.size.height : 0
    }
}

extension SearchViewController: DidSearchFiltersDelegate {
    func searchFiltersTapped(users: [UserObject]) {
        self.users = users
    }
}
