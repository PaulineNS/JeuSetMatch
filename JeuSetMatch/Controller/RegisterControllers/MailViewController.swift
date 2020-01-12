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
    
    var currentUser: User?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.registerSegue else { return }
        guard let navVc = segue.destination as? UITabBarController else { return }
        guard let searchVc = navVc.viewControllers?[0] as? SearchViewController, let messagesVc = navVc.viewControllers?[1] as? MessagesViewController, let profileVc = navVc.viewControllers?[2] as? ProfileViewController else {return}
        searchVc.currentUser = currentUser
        messagesVc.currentUser = currentUser
        profileVc.currentUser = currentUser
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("error, \(error!)")
                return
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let data = ["userAge": self.currentUser?.birthDate as Any,
                            "userGender": self.currentUser?.sexe as Any,
                            "userLevel": self.currentUser?.level as Any,
                            "userCity": self.currentUser?.city as Any,
                            "userName": self.currentUser?.pseudo as Any,
                            "userImage": self.currentUser?.image as Any,
                            "userUid": uid]
                self.db.collection("users").document("\(uid)").setData(data) { (error) in
                    if error != nil {
                        print(error!)
                    } else {
                        self.currentUser = User(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: data["userUid"] as? String)
                        self.performSegue(withIdentifier: K.registerSegue, sender: self)
                        
                    }
                }
            }
        }
    }
}
