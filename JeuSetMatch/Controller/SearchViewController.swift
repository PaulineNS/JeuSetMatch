//
//  UsersViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
//    let fireStoreService = FirestoreService()
    let customLoader = CustomLoader()
    
    // MARK: - Variables
    var userUseCase: UserUseCase?

    
    var currentUser: UserObject?
    private var users: [UserObject] = []
    
    // MARK: - Outlets
    
    @IBOutlet private weak var usersTableView: UITableView!
    @IBOutlet private weak var filterBarButton: UIBarButtonItem!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customLoader.setAlpha = 0.5
        customLoader.gifName = "ball"
        customLoader.viewColor = UIColor.gray
        let firestoreUser = FirestoreUserService()
        self.userUseCase = UserUseCase(user: firestoreUser)
        self.tabBarController?.navigationItem.hidesBackButton = true
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.register(UINib(nibName: K.userCellNibName, bundle: nil), forCellReuseIdentifier: K.userCellIdentifier)
        fetchUser()
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
    
    @IBAction func didTapFilterButton(_ sender: Any) {
        performSegue(withIdentifier: K.SearchToFilterSegue, sender: nil)
    }
    
    // MARK: - Methods
    
    private func fetchUser() {
        customLoader.showLoaderView()
        userUseCase?.fetchUser { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let users):
                self.users.append(users)
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)                
            }
        }
    }
}

// MARK: - TableView DataSource

extension SearchViewController: UITableViewDataSource {
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
}

// MARK: - TableView Delegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.currentUser = user
        performSegue(withIdentifier: K.SearchToProfileSegue, sender: nil)
    }
}

extension SearchViewController: DidSearchFiltersDelegate {
    func searchFiltersTapped(users: [UserObject]) {
        self.users = users
    }
}
