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
    
    private var loginUseCase: LoginUseCase?
    private var currentUser: UserObject?
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firestoreLogin = FirestoreLoginService()
        self.loginUseCase = LoginUseCase(client: firestoreLogin)
        alertLabel.isHidden = true
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.loginSegue else { return }
        guard let navVC = segue.destination as? UINavigationController else { return }
        navVC.modalPresentationStyle = .fullScreen
    }
    
    // MARK: - Actions
    
    @IBAction private func loginPressed(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}
        loginUseCase?.login(with: email, password: password) { (result) in
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
