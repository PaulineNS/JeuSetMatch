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

class PseudoViewController: UIViewController {
    
    var birthDate = Date()
    var userGender = ""
    var userLevel = ""
    var userCity = ""
    var userPseudo = ""
    var userPicture = UIImage()
    
    let image = UIImagePickerController()
    let emptyPicture = UIImage(named: "addPictureProfil")

    @IBOutlet weak var pseudoTextfield: UITextField!
    @IBOutlet weak var profilPictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.delegate = self
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilPicture))
        profilPictureImageView.isUserInteractionEnabled = true
        profilPictureImageView.addGestureRecognizer(singleTap)
    }
    
    @IBAction func pseudoTextFieldChanged(_ sender: UITextField) {
        while sender.text?.count ?? 0 <= 2 { }
        userPseudo = sender.text ?? ""
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
    }
    
    //Remove the view when the user click on cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
