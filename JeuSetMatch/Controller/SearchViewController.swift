//
//  UsersViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private let customLoader = CustomLoader()
    private var userUseCase: UserUseCase?
    private var users: [UserObject] = []
    
    // MARK: - Outlets
    
    @IBOutlet private weak var usersTableView: UITableView! { didSet { usersTableView.tableFooterView = UIView() }}
    @IBOutlet private weak var filterBarButton: UIBarButtonItem!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firestoreUser = FirestoreUserService()
        self.userUseCase = UserUseCase(user: firestoreUser)
        self.tabBarController?.navigationItem.hidesBackButton = true
        usersTableView.register(UINib(nibName: K.userCellNibName, bundle: nil), forCellReuseIdentifier: K.userCellIdentifier)
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = filterBarButton
        usersTableView.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SearchToProfileSegue {
            guard let profileVc = segue.destination as? ProfileViewController else {return}
            profileVc.navigationItem.rightBarButtonItem = nil
            profileVc.currentUser = currentUser
            profileVc.IsSegueFromSearch = true
        }
        if segue.identifier == K.SearchToFilterSegue {
            guard let filterVc = segue.destination as? FilterViewController else {return}
            filterVc.didSearchFiltersDelegate = self
        }
    }
    
    // MARK: - Actions

    @IBAction private func didTapFilterButton(_ sender: Any) {
        performSegue(withIdentifier: K.SearchToFilterSegue, sender: nil)
    }
    
    // MARK: - Methods
    
    func fetchUsers(){
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
        userUseCase?.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: { (result) in
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
        userUseCase?.fetchUserInformationsDependingAllFilters(gender: gender, city: city, level: level, completion: { (result) in
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
        userUseCase?.fetchUserWithoutFilters(completion: { (result) in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.userCellIdentifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell()}
        cell.userName.text = user.pseudo
        cell.userImage.image = UIImage(data: user.image ?? Data())
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.currentUser = user
        performSegue(withIdentifier: K.SearchToProfileSegue, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Aucun joueur ne correspond à votre recherche"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
        
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "reciplease")
//        imageView.contentMode = .scaleAspectFill
//        imageView.contentMode = .center
//        return imageView
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
