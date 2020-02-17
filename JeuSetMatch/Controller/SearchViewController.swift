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
        navigationBarCustom()
//        let backgroundImage = UIImage(named: "players")
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        usersTableView.backgroundView = imageView
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
    
    func fetchUsersWithOneFilter(field1: String, field1value: String){
        fetchUsersDependingOneFilter(field1: field1, field1value: field1value, onSuccess: {(users) in
            self.users.append(users)
            self.reloadTableViewInMainQueue()
        }, onNone: {
            self.reloadTableViewInMainQueue()
        })
    }

    func fetchUsersWithTwoFilters(field1: String, field1value: String, field2: String, field2Value: String){
        fetchUsersDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, onSuccess: {(users) in
            self.users.append(users)
            self.reloadTableViewInMainQueue()
        }, onNone: {
            self.reloadTableViewInMainQueue()
        })
    }

    func fetchUsersWithThreeFilters(gender: String, city: String, level: String) {
        fetchUsersDependingThreeFilters(gender: gender, city: city, level: level, onSuccess: {(users) in
            self.users.append(users)
            self.reloadTableViewInMainQueue()
        }, onNone: {
            self.reloadTableViewInMainQueue()
        })
    }

    func fetchUsersWithoutFilters(){
        fetchUsersWithoutFilters(onSuccess: { (users) in
            self.users.append(users)
            self.reloadTableViewInMainQueue()
        }, onNone: {
            self.reloadTableViewInMainQueue()
        })
    }
    
    func reloadTableViewInMainQueue() {
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
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
        cell.backgroundColor = .clear
        cell.userName.text = user.pseudo
        cell.userImage.makeRounded()
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
            make.right.equalTo(view).offset(-15.0)
            make.left.equalTo(view).offset(15.0)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return users.isEmpty ? tableView.bounds.size.height : 0
    }
}

// MARK: - DidSearchFiltersDelegate

extension SearchViewController: DidSearchFiltersDelegate {
    func searchFiltersTapped(users: [UserObject]) {
        self.users = users
    }
}
