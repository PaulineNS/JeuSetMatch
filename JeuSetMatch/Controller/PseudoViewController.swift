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
import Firebase

extension UITextField {
    
    func checkPseudo(field: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(K.FStore.userCollectionName)
        collectionRef.whereField(K.FStore.userNameField, isEqualTo: field).getDocuments { (snapshot, error) in
            if let e = error {
                print("Error getting document: \(e)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()[K.FStore.userNameField] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
}

class PseudoViewController: UIViewController {
    
    var birthDate = Date()
    var userGender = ""
    var userLevel = ""
    var userCity = ""
    var userPseudo = ""
    var userPicture = UIImage()
    
    let db = Firestore.firestore()
    let image = UIImagePickerController()
    let emptyPicture = UIImage(named: "addPictureProfil")
    
    @IBOutlet weak var pseudoTextfield: UITextField!
    @IBOutlet weak var profilPictureImageView: UIImageView!
    @IBOutlet weak var pictureAlertLabel: UILabel!
    @IBOutlet weak var pseudoAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.delegate = self
        pictureAlertLabel.isHidden = true
        pseudoAlertLabel.isHidden = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilPicture))
        profilPictureImageView.isUserInteractionEnabled = true
        profilPictureImageView.addGestureRecognizer(singleTap)
    }
    
    @IBAction func pseudoTextFieldChanged(_ sender: UITextField) {
        if sender.text?.count ?? 0 < 4 {
            self.pseudoAlertLabel.isHidden = false
            self.pseudoAlertLabel.text = "Votre pseudo doit comporter plus de 4 charactères"
            self.pseudoTextfield.textColor = #colorLiteral(red: 0.8514410622, green: 0.2672892915, blue: 0.1639432118, alpha: 1)
            self.userPseudo = ""
        } else {
            sender.checkPseudo(field: sender.text ?? "") { (success) in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.PseudoToMailSegue else { return }
        guard let mailVc = segue.destination as? MailViewController else { return }
        mailVc.birthDate = birthDate
        mailVc.userGender = userGender
        mailVc.userLevel = userLevel
        mailVc.userCity = userCity
        mailVc.userPseudo = userPseudo
        mailVc.userPicture = userPicture
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
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
    
    @objc func didTapProfilPicture() {
        onPictureClick()
    }
    
    func onPictureClick() {
        // Selecting source of pictures
        let actionSheet = UIAlertController(title: "Source de la photo", message: "Choisissez une source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Appareil photo", style: .default, handler: { (action:UIAlertAction) in
            
            //Access to camera
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
                case .authorized:
                    self.authorizedAccessToCamera()
                case .notDetermined:
                    if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized {
                        self.authorizedAccessToCamera()
                    }
                case .restricted:
                    self.showRestrictedAlertForCamera()
                case .denied:
                    self.showDeniedAlertForCamera()
                @unknown default:
                    fatalError()
                }
            } else {
                print ("L'appareil photo n'est pas disponible")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Galerie photos", style: .default, handler: { (action:UIAlertAction) in
            
            // Access to photo library
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                PHPhotoLibrary.requestAuthorization { (status) in
                    switch status {
                    case .authorized:
                        self.authorizedAccessToPhotoLibrary()
                    case .notDetermined:
                        if status == PHAuthorizationStatus.authorized {
                            self.authorizedAccessToPhotoLibrary()
                        }
                    case .restricted:
                        self.showRestrictedAlertForPhotoLibrary()
                    case .denied:
                        self.showDeniedAlertForPhotoLibrary()
                    @unknown default:
                        fatalError()
                    }
                }
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Different access to the photo library
    private func showDeniedAlertForPhotoLibrary() {
        let alert = UIAlertController(title: "Accès à la galerie photos refusé", message: "Veuillez mettre à jour vos réglages si vous souhaitez autoriser l'accès à votre galerie photos", preferredStyle: .alert)
        let goToSettingsAction = UIAlertAction(title: "Aller aux réglages", style: .default) { (action) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        }
        alert.addAction(goToSettingsAction)
    }
    
    private func showRestrictedAlertForPhotoLibrary() {
        let alert = UIAlertController(title: "Accès à la galerie photos limité", message: "L'accès à votre galerie photo est restreint. Vous ne pouvez pas y accéder", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
    }
    
    private func authorizedAccessToPhotoLibrary() {
        self.image.sourceType = .photoLibrary
        self.present(self.image, animated: true, completion: nil)
    }
    
    // Different access to the camera
    private func showDeniedAlertForCamera() {
        let alert = UIAlertController(title: "Accès à l'appareil photos refusé", message: "Veuillez mettre à jour vos réglages si vous souhaitez autoriser l'accès à votre appareil photos", preferredStyle: .alert)
        let goToSettingsAction = UIAlertAction(title: "Aller aux réglages", style: .default) { (action) in
            DispatchQueue.main.async {
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:])
            }
        }
        alert.addAction(goToSettingsAction)
    }
    
    private func showRestrictedAlertForCamera() {
        let alert = UIAlertController(title: "Accès à l'appareil photos limité", message: "L'accès à votre appareil photo est restreint. Vous ne pouvez pas y accéder", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
    }
    
    private func authorizedAccessToCamera() {
        self.image.sourceType = .camera
        self.present(self.image, animated: true, completion: nil)
    }
}

extension PseudoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageView = profilPictureImageView {
                imageView.contentMode = .scaleAspectFill
                imageView.image = pickedImage
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
