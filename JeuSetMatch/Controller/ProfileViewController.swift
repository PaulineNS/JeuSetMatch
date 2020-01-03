//
//  ProfileViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var pseudoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard IsSegueFromSearch == true else {
            loadCurrentUserInformations()
            return
        }
        loadAnotherUserInformations()
    }
    
    let db = Firestore.firestore()
    var IsSegueFromSearch = false
    var userPseudo = ""
    var userInformations: [User] = []
    
    func loadAnotherUserInformations() {
        db.collection(K.FStore.userCollectionName).whereField(K.FStore.userNameField, isEqualTo: userPseudo).addSnapshotListener { (querySnapshot, error) in
            self.userInformations = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data[K.FStore.userNameField] as? String ,let userGender = data[K.FStore.userGenderField] as? String, let userCity = data[K.FStore.userCityField] as? String, let userLevel = data[K.FStore.userLevelField] as? String else {return}
                    let user = User(pseudo: userPseudo, sexe: userGender, level: userLevel, city: userCity)
                    self.userInformations.append(user)
                    DispatchQueue.main.async {
                        self.pseudoLabel.text = userPseudo
                        self.genderLabel.text = userGender
                        self.cityLabel.text = userCity
                        self.levelLabel.text = userLevel
                    }
                }
            }
        }
    }
    
    func loadCurrentUserInformations() {
        db.collection(K.FStore.userCollectionName).whereField(K.FStore.userUidField, isEqualTo: Auth.auth().currentUser?.uid as Any).addSnapshotListener { (querySnapshot, error) in
            self.userInformations = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data[K.FStore.userNameField] as? String ,let userGender = data[K.FStore.userGenderField] as? String, let userCity = data[K.FStore.userCityField] as? String, let userLevel = data[K.FStore.userLevelField] as? String else {return}
                    let user = User(pseudo: userPseudo, sexe: userGender, level: userLevel, city: userCity)
                    self.userInformations.append(user)
                    DispatchQueue.main.async {
                        self.pseudoLabel.text = userPseudo
                        self.genderLabel.text = userGender
                        self.cityLabel.text = userCity
                        self.levelLabel.text = userLevel
                    }
                }
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
