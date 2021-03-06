//
//  MailViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class MailViewController: UIViewController {
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var registerUsecase: RegisterUseCase?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    // MARK: - Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        alertLabel.isHidden = true
        let firestoreRegister = FirestoreRegisterService()
        self.registerUsecase = RegisterUseCase(client: firestoreRegister)
    }
    
    // MARK: - Segue
    
    /// prepare segue to SearchVc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segue.registerSegue else { return }
        guard let navVC = segue.destination as? UINavigationController else { return }
        navVC.modalPresentationStyle = .fullScreen
    }
    
    // MARK: - Actions
    
    /// Action while user press register button
    @IBAction private func registerButtonPressed(_ sender: Any) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text, let userAge = currentUser?.birthDate, let userGender = currentUser?.sexe, let userLevel = currentUser?.level, let userCity = currentUser?.city, let userName = currentUser?.pseudo, let userImage = currentUser?.image else {
            return}
        registerUsecase?.register(email: email, password: password, userAge: userAge, userGender: userGender, userLevel: userLevel, userCity: userCity, userName: userName, userImage: userImage) { (result) in
            switch result {
            case .success(let user):
                self.currentUser = user
                self.alertLabel.isHidden = true
                self.performSegue(withIdentifier: Constants.Segue.registerSegue, sender: self)
            case .failure(let error):
                self.alertLabel.isHidden = false
                self.alertLabel.text = "Merci de saisir une adresse mail et un mot de passe valides"
                print(error.localizedDescription)
            }
        }
    }
}
