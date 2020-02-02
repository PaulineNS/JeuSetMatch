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
    
    // MARK: - Instensiation
    
    private let image = UIImagePickerController()
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var registerUsecase: RegisterUseCase?
    private var userPseudo: String?
    private var isImageChanged = false
    private var userPicture = UIImage()
    
    // MARK: - Outlets

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
        guard segue.identifier == Constants.Segue.pseudoToMailSegue else { return }
        guard let mailVc = segue.destination as? MailViewController else { return }
        guard let pictureData = userPicture.jpegData(compressionQuality: 0.1) else { return }
        mailVc.currentUser = UserObject(pseudo: userPseudo, image: pictureData, sexe: currentUser?.sexe, level: currentUser?.level, city: currentUser?.city, birthDate: currentUser?.birthDate, uid: nil)
    }
    
    // MARK: - Methods

    private func manageAlertLabel(visibility: Bool, text: String, color: UIColor){
        pseudoAlertLabel.isHidden = visibility
        pseudoAlertLabel.text = text
        pseudoTextfield.textColor = color
    }
    
    // MARK: - Actions
    
    @IBAction private func pseudoTextFieldChanged(_ sender: UITextField) {
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

    @IBAction private func continueButtonPressed(_ sender: UIButton) {
        guard isImageChanged == true else {
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
        performSegue(withIdentifier: Constants.Segue.pseudoToMailSegue, sender: nil)
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
                isImageChanged = true
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
