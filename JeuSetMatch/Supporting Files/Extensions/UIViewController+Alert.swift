//
//  UIViewController+Alert.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

// MARK: - Manage Alerts

extension UIViewController {
        
    /// Display  an alert  with multiChoice
    func presentMultiChoiceAlert(title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    ///Display a unique message alert
    func presentMessageAlert(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
