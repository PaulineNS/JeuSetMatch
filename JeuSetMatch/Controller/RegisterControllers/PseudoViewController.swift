//
//  PseudoViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

final class PseudoViewController: UIViewController {
    
    // MARK: - Variables
    
    var registerUsecase: RegisterUseCase?
    
    var currentUser: UserObject?
    private var userPseudo = ""
    private var userPicture = UIImage()
    private let image = UIImagePickerController()
    private let emptyPicture = UIImage(named: "addPictureProfil")
    
    @IBOutlet private weak var pseudoTextfield: UITextField!
    @IBOutlet private weak var profilPictureImageView: UIImageView!
    @IBOutlet private weak var pictureAlertLabel: UILabel!
    @IBOutlet private weak var pseudoAlertLabel: UILabel!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firestoreRegister = FirestoreRegisterService()
        self.registerUsecase = RegisterUseCase(client: firestoreRegister)
        image.delegate = self
        pictureAlertLabel.isHidden = true
        pseudoAlertLabel.isHidden = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilPicture))
        profilPictureImageView.isUserInteractionEnabled = true
        profilPictureImageView.addGestureRecognizer(singleTap)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.PseudoToMailSegue else { return }
        guard let mailVc = segue.destination as? MailViewController else { return }
        guard let pictureData = userPicture.jpegData(compressionQuality: 0.1) else { return }
        mailVc.currentUser = UserObject(pseudo: userPseudo, image: pictureData, sexe: currentUser?.sexe, level: currentUser?.level, city: currentUser?.city, birthDate: currentUser?.birthDate, uid: nil)
    }
    
    // MARK: - Actions
    
    @IBAction private func pseudoTextFieldChanged(_ sender: UITextField) {
        if sender.text?.count ?? 0 < 4 {
            self.pseudoAlertLabel.isHidden = false
            self.pseudoAlertLabel.text = "Votre pseudo doit comporter plus de 4 charactères"
            self.pseudoTextfield.textColor = #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1)
            self.userPseudo = ""
        } else {
            registerUsecase?.checkPseudoDisponibility(field: sender.text ?? "") { (success) in
                if success == true {
                    DispatchQueue.main.async {
                        self.pseudoAlertLabel.isHidden = false
                        self.pseudoAlertLabel.text = "Ce pseudo n'est pas disponible"
                        self.pseudoTextfield.textColor = #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1)
                        self.userPseudo = ""
                    }
                } else {
                    DispatchQueue.main.async {
                        self.pseudoAlertLabel.isHidden = true
                        self.pseudoTextfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        self.userPseudo = sender.text ?? ""
                    }
                    
                }
            }
        }
    }
    
    @IBAction private func continueButtonPressed(_ sender: UIButton) {
        guard profilPictureImageView.image != emptyPicture else {
            pictureAlertLabel.isHidden = false
            pictureAlertLabel.text = "Veuillez choisir une photo de profil avant de continuer"
            return
        }
        guard userPseudo != "" else {
            pseudoAlertLabel.isHidden = false
            pseudoAlertLabel.text = "Veuillez renseigner un pseudo avant de continuer"
            return
        }
        pictureAlertLabel.isHidden = true
        pseudoAlertLabel.isHidden = true
        performSegue(withIdentifier: K.PseudoToMailSegue, sender: nil)
    }
    
    @objc private func didTapProfilPicture() {
        onPictureClick(image: image)
    }
}

// MARK: - UIImage Picker Controller

extension PseudoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageView = profilPictureImageView {
                imageView.contentMode = .scaleAspectFill
                imageView.image = pickedImage
                userPicture = pickedImage
            } else {
                print ("selectedUIImageView is nil")
            }
        } else {
            print ("info[UIImagePickerController.InfoKey.originalImage] isn't an UIImage")
        }
        
        //Remove the view
        picker.dismiss(animated: true, completion: nil)
        pictureAlertLabel.isHidden = true
    }
    
    //Remove the view when the user click on cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


