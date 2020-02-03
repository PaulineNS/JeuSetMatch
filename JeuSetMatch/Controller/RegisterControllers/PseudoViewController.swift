//
//  PseudoViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

class PseudoViewController: UIViewController {

    var currentUser: UserObject?
    private var userPseudo: String?
    private var registerUsecase: RegisterUseCase?

    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var pseudoAlert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firestoreRegister = FirestoreRegisterService()
        self.registerUsecase = RegisterUseCase(client: firestoreRegister)
        pseudoAlert.isHidden = true
    }
    
    private func manageAlertLabel(visibility: Bool, text: String, color: UIColor){
        pseudoAlert.isHidden = visibility
        pseudoAlert.text = text
        pseudoTextField.textColor = color
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "PseudoToMail" else { return }
        guard let mailVc = segue.destination as? MailViewController else { return }
        mailVc.currentUser = UserObject(pseudo: userPseudo, image: currentUser?.image, sexe: currentUser?.sexe, level: currentUser?.level, city: currentUser?.city, birthDate: currentUser?.birthDate, uid: nil)
    }
    
    @IBAction func pseudoTxtFieldChanged(_ sender: UITextField) {
        if sender.text?.count ?? 0 < 4 {
            manageAlertLabel(visibility: false, text: "Votre pseudo doit comporter plus de 4 charactères", color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        } else {
            registerUsecase?.checkPseudoDisponibility(field: sender.text ?? "") { (success) in
                guard success == true else {
                    DispatchQueue.main.async {
                        self.manageAlertLabel(visibility: true, text: "", color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                        self.userPseudo = sender.text ?? ""
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.manageAlertLabel(visibility: false, text: "Ce pseudo n'est pas disponible", color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
                }
            }
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        guard userPseudo != nil else {
            pseudoAlert.isHidden = false
            pseudoAlert.text = "Veuillez renseigner un pseudo avant de continuer"
            return
        }
        pseudoAlert.isHidden = true
        performSegue(withIdentifier: "PseudoToMail", sender: nil)
    }
    
    
}
