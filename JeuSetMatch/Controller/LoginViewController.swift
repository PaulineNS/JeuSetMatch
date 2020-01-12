//
//  LoginViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 19/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    let db = Firestore.firestore()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.loginSegue else { return }
        guard let navVc = segue.destination as? UITabBarController else { return }
        guard let searchVc = navVc.viewControllers?[0] as? SearchViewController, let messagesVc = navVc.viewControllers?[1] as? MessagesViewController, let profileVc = navVc.viewControllers?[2] as? ProfileViewController else {return}
        searchVc.currentUser = currentUser
        messagesVc.currentUser = currentUser
        profileVc.currentUser = currentUser
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                self.alertLabel.isHidden = false
                self.alertLabel.text = e.localizedDescription
            } else {
//                self.saveCurrentUserInformations()
                self.performSegue(withIdentifier: K.loginSegue, sender: self)
            }
        }
    }
    
//    func saveCurrentUserInformations() {
//        db.collection(K.FStore.userCollectionName).whereField(K.FStore.userUidField, isEqualTo: Auth.auth().currentUser?.uid as Any).addSnapshotListener { (querySnapshot, error) in
//            if let e = error {
//                print("There was an issue retrieving data from Firestore. \(e)")
//            } else {
//                guard let snapshotDocuments = querySnapshot?.documents else {return}
//                for doc in snapshotDocuments {
//                    let data = doc.data()
//                    guard let userPseudo = data[K.FStore.userPseudoField] as? String ,let userGender = data[K.FStore.userGenderField] as? String, let userCity = data[K.FStore.userCityField] as? String, let userLevel = data[K.FStore.userLevelField] as? String, let userPicture = data[K.FStore.userPictureField] as? Data, let userBirthDate = data[K.FStore.userAgeField] as? String else {return}
//                    let user = User(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate)
//                    self.currentUser = user
//                }
//            }
//        }
//    }
}
