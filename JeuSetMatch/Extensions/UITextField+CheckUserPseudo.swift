//
//  UITextField+CheckUserPseudo.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 14/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit
import Foundation
import Firebase

extension UITextField {
    
    // MARK: - Properties

    func checkPseudo(field: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(K.FStore.userCollectionName)
        collectionRef.whereField(K.FStore.userPseudoField, isEqualTo: field).getDocuments { (snapshot, error) in
            if let e = error {
                print("Error getting document: \(e)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()[K.FStore.userPseudoField] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
}
