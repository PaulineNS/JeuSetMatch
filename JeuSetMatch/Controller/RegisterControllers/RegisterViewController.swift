//
//  RegisterViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 19/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var image: UITextField!
        
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}
     
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                self.alertLabel.isHidden = false
                self.alertLabel.text = e.localizedDescription
            } else {
               
                guard let userUid = Auth.auth().currentUser?.uid ,let userName = self.name.text, let userGender = self.gender.text, let userLevel = self.level.text, let userImage = self.image.text, let userCity = self.city.text, let userAge = self.age.text else {return}
                
                self.db.collection(K.FStore.userCollectionName).addDocument(data: [
                    K.FStore.userPseudoField: userName,
                    K.FStore.userCityField: userCity,
                    K.FStore.userLevelField: userLevel,
                    K.FStore.userPictureField: userImage,
                    K.FStore.userGenderField: userGender,
                    K.FStore.userUidField: userUid,
                    K.FStore.userAgeField: userAge
                    ]) { (error) in
                        guard let e = error else {
                            print("Successfully saved data.")
                            return
                        }
                        print("There was an issue saving data to firestore, \(e)")
                }
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
}
