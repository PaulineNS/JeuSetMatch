//
//  MailViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class MailViewController: UIViewController {
    
    var birthDate = ""
    var userGender = ""
    var userLevel = ""
    var userCity = ""
    var userPseudo = ""
    var userPicture = Data()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                
            } else {
                print("ici")
                //let imageData = self.userPicture.jpegData(compressionQuality: 1.0)
                guard let userUid = Auth.auth().currentUser?.uid else {
                    print("no")
                    return }
                
                self.db.collection(K.FStore.userCollectionName).addDocument(data: [
                    K.FStore.userAgeField: self.birthDate,
                    K.FStore.userGenderField: self.userGender,
                    K.FStore.userLevelField: self.userLevel,
                    K.FStore.userCityField: self.userCity,
                    K.FStore.userNameField: self.userPseudo,
                    K.FStore.userPictureField: self.userPicture,
                    K.FStore.userUidField: userUid
                    ], completion: { (error) in
                        DispatchQueue.main.async {
                            if let e = error {
                                print("There was an issue saving data to firestore, \(e)")
                            } else {
                                print("Successfully saved data.")
                                self.performSegue(withIdentifier: K.registerSegue, sender: self)
                            }
                        }
                })
            }
        }
    }
}
