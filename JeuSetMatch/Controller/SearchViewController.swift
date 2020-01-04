//
//  UsersViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    var users: [User] = []
    var userPseudo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.register(UINib(nibName: K.userCellNibName, bundle: nil), forCellReuseIdentifier: K.userCellIdentifier)
        loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = filterBarButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.SearchToProfileSegue else { return }
        guard let pseudoVc = segue.destination as? ProfileViewController else {return}
        pseudoVc.userPseudo = userPseudo
        pseudoVc.IsSegueFromSearch = true
    }
    
    func loadUsers(){
        db.collection(K.FStore.userCollectionName).addSnapshotListener { (querySnapshot, error) in
            self.users = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userName = data[K.FStore.userNameField] as? String, let userGender = data[K.FStore.userGenderField] as? String, let userLevel = data[K.FStore.userLevelField] as? String, let userCity = data[K.FStore.userCityField] as? String, let userImageData = data[K.FStore.userPictureField] as? Data, let userBirthDate = data[K.FStore.userAgeField] as? String else {return}
                    let newUser = User(pseudo: userName, image: userImageData, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate)
                    //, age: userAge) image: userImage
                    self.users.append(newUser)
                    DispatchQueue.main.async {
                        self.usersTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.userCellIdentifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell()}
        
        cell.userName.text = user.pseudo
        cell.userImage.image = UIImage(data: user.image)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.userPseudo = user.pseudo
        performSegue(withIdentifier: K.SearchToProfileSegue, sender: nil)
    }
}
