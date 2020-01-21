//
//  LoginViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 19/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    // MARK: - Variables
    
    let firestoreService = FirestoreService()
    var currentUser: UserObject?
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertLabel.isHidden = true
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.loginSegue else { return }
        guard let navVC = segue.destination as? UINavigationController else { return }
        guard let tabVc = navVC.viewControllers.first as? UITabBarController else { return }
        guard let searchVc = tabVc.viewControllers?[0] as? SearchViewController, let messagesVc = tabVc.viewControllers?[1] as? MessagesViewController, let profileVc = tabVc.viewControllers?[2] as? ProfileViewController else {return}
        navVC.modalPresentationStyle = .fullScreen
        searchVc.currentUser = currentUser
        messagesVc.currentUser = currentUser
        profileVc.currentUser = currentUser
    }
    
    // MARK: - Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}

        firestoreService.login(email: email, password: password) { (result) in
            switch result {
            case .success :
                self.performSegue(withIdentifier: K.loginSegue, sender: self)
                
            case .failure(let error):
                print(error.localizedDescription)
                self.alertLabel.isHidden = false
                self.alertLabel.text = error.localizedDescription
            }
        }
    }
}
