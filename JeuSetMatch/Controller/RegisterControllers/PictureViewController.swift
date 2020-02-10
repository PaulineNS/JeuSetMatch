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

final class PictureViewController: UIViewController {
    
    // MARK: - Instensiation
    
    private let image = UIImagePickerController()
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var isImageChanged = false
    private var userPicture = UIImage()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var profilPictureImageView: UIImageView!
    @IBOutlet private weak var pictureAlertLabel: UILabel!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilPictureImageView.makeRounded()
        image.delegate = self
        pictureAlertLabel.isHidden = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilPicture))
        profilPictureImageView.isUserInteractionEnabled = true
        profilPictureImageView.addGestureRecognizer(singleTap)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segue.pictureToPseudo else { return }
        guard let pseudoVc = segue.destination as? PseudoViewController else { return }
        guard let pictureData = userPicture.jpegData(compressionQuality: 0.1) else { return }
        pseudoVc.currentUser = UserObject(pseudo: nil, image: pictureData, sexe: currentUser?.sexe, level: currentUser?.level, city: currentUser?.city, birthDate: currentUser?.birthDate, uid: nil)
    }
    
    // MARK: - Actions
    
    @IBAction private func continueButtonPressed(_ sender: UIButton) {
        guard isImageChanged == true else {
            pictureAlertLabel.isHidden = false
            pictureAlertLabel.text = "Veuillez choisir une photo de profil avant de continuer"
            return
        }
        pictureAlertLabel.isHidden = true
        performSegue(withIdentifier: Constants.Segue.pictureToPseudo, sender: nil)
    }
    
    @objc private func didTapProfilPicture() {
        onPictureClick(image: image)
    }
}

// MARK: - UIImage Picker Controller

extension PictureViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
