//
//  UsersViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

final class SearchViewController: UIViewController {
    
    // MARK: - Variables
    
    var currentUser: User?
    
    private let db = Firestore.firestore()
    private var users: [User] = []
    private var userPseudo = ""
    
    // MARK: - Outlets
    
    @IBOutlet private weak var usersTableView: UITableView!
    @IBOutlet private weak var filterBarButton: UIBarButtonItem!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.register(UINib(nibName: K.userCellNibName, bundle: nil), forCellReuseIdentifier: K.userCellIdentifier)
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = filterBarButton
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.SearchToProfileSegue else { return }
        guard let pseudoVc = segue.destination as? ProfileViewController else {return}
        pseudoVc.navigationItem.rightBarButtonItem = nil
        pseudoVc.currentUser = currentUser
        pseudoVc.userPseudo = userPseudo
        pseudoVc.IsSegueFromSearch = true
    }
    
    //    func checkIfUserIsLoggedIn() {
    //        if Auth.auth().currentUser?.uid == nil {
    //            performSegue(withIdentifier: K.SearchToWelcomeSegue, sender: nil)
    //        } else {
    //            fetchUser()
    //        }
    //    }
    @IBAction func didTapFilterButton(_ sender: Any) {
        performSegue(withIdentifier: K.SearchToFilterSegue, sender: nil)
    }
    
    // MARK: - Methods
    
    private func fetchUser() {
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let user = User(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: document.documentID)
                    self.users.append(user)
                    
                    DispatchQueue.main.async {
                        self.usersTableView.reloadData()
                    }
                    
                }
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
        self.userPseudo = user.pseudo ?? ""
        self.currentUser = user
        performSegue(withIdentifier: K.SearchToProfileSegue, sender: nil)
    }
}
