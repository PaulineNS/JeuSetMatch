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
    var registerUsecase: RegisterUseCase?
    var currentUser: UserObject?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firestoreRegister = FirestoreRegisterService()
        self.registerUsecase = RegisterUseCase(client: firestoreRegister)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.registerSegue else { return }
        guard let navVC = segue.destination as? UINavigationController else { return }
        guard let tabVc = navVC.viewControllers.first as? UITabBarController else { return }
        guard let searchVc = tabVc.viewControllers?[0] as? SearchViewController, let messagesVc = tabVc.viewControllers?[1] as? MessagesViewController, let profileVc = tabVc.viewControllers?[2] as? ProfileViewController else {return}
        navVC.modalPresentationStyle = .fullScreen
        searchVc.currentUser = currentUser
        messagesVc.currentUser = currentUser
        profileVc.currentUser = currentUser
    }
    
    // MARK: - Actions
    
    @IBAction private func registerButtonPressed(_ sender: Any) {
        
        guard let email = emailTextfield.text, let password = passwordTextfield.text, let userAge = currentUser?.birthDate, let userGender = currentUser?.sexe, let userLevel = currentUser?.level, let userCity = currentUser?.city, let userName = currentUser?.pseudo, let userImage = currentUser?.image else {
            return}
        print("soucis")
        registerUsecase?.register(email: email, password: password, userAge: userAge, userGender: userGender, userLevel: userLevel, userCity: userCity, userName: userName, userImage: userImage) { (result) in
            switch result {
            case .success(let user):
                print("success")
                self.currentUser = user
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
