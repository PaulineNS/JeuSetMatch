//
//  UIViewController+ImagePicker.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 27/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

// MARK: - Manage Picture Picker

extension UIViewController {
    
    public func onPictureClick(image: UIImagePickerController) {
            // Selecting source of pictures
            let actionSheet = UIAlertController(title: "Source de la photo", message: "Choisissez une source", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Appareil photo", style: .default, handler: { (action:UIAlertAction) in
                
                //Access to camera
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
                    case .authorized:
                        self.authorizedAccessToCamera(image: image)
                    case .notDetermined:
                        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized {
                            self.authorizedAccessToCamera(image: image)
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
                            DispatchQueue.main.async {
                                self.authorizedAccessToPhotoLibrary(image: image)
                            }
                        case .notDetermined:
                            if status == PHAuthorizationStatus.authorized {
                                DispatchQueue.main.async {
                                    self.authorizedAccessToPhotoLibrary(image: image)
                                }
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
        
        private func authorizedAccessToPhotoLibrary(image: UIImagePickerController) {
            image.sourceType = .photoLibrary
            self.present(image, animated: true, completion: nil)
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
        
    private func authorizedAccessToCamera(image: UIImagePickerController) {
            image.sourceType = .camera
            self.present(image, animated: true, completion: nil)
        }

}
