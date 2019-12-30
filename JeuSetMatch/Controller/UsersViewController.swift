//
//  UsersViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var usersTableView: UITableView!
    
    let db = Firestore.firestore()
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.dataSource = self
        usersTableView.register(UINib(nibName: K.userCellNibName, bundle: nil), forCellReuseIdentifier: K.userCellIdentifier)
        loadUsers()
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
                    guard let userName = data[K.FStore.userNameField] as? String, let userImage = data[K.FStore.userPictureField] as? String, let userGender = data[K.FStore.userGenderField] as? String, let userLevel = data[K.FStore.userLevelField] as? String, let userCity = data[K.FStore.userCityField] as? String, let userAge = data[K.FStore.userAgeField] as? String else {return}
                    let newUser = User(pseudo: userName, image: userImage, sexe: userGender, level: userLevel, city: userCity, age: userAge)
                    self.users.append(newUser)
                    DispatchQueue.main.async {
                        self.usersTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.userCellIdentifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell()}
        
        cell.userImage.image = UIImage(named: user.image)
        cell.userName.text = user.pseudo
        
        return cell
    }
    
    
}
