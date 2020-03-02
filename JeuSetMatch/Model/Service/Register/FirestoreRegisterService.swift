//
//  FirestoreRegisterService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Firebase

class FirestoreRegisterService: RegisterUseCaseOutput {
    
    private let db = Firestore.firestore()
    
    /// Register to firebase
    func register(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping RegisterCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print("error, \(error!)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let data = [Constants.FStore.userAgeField: userAge,
                            Constants.FStore.userGenderField: userGender,
                            Constants.FStore.userLevelField: userLevel,
                            Constants.FStore.userCityField: userCity,
                            Constants.FStore.userPseudoField: userName,
                            Constants.FStore.userPictureField: userImage,
                            Constants.FStore.userUidField: uid]
                self.db.collection(Constants.FStore.userCollectionName).document("\(uid)").setData(data) { (error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let currentUser = UserObject(pseudo: data[Constants.FStore.userPseudoField] as? String, image: data[Constants.FStore.userPictureField] as? Data, sexe: data[Constants.FStore.userGenderField] as? String, level: data[Constants.FStore.userLevelField] as? String, city: data[Constants.FStore.userCityField] as? String, birthDate: data[Constants.FStore.userAgeField] as? String, uid: data[Constants.FStore.userUidField] as? String)
                    completion(.success(currentUser))
                }
            }
        }
    }
    
    /// Checking if a pseudo already exist on the dataBase
    func checkPseudoDisponibility(field: String, completion: @escaping CheckPseudoDisponibilityCompletion) {
        let collectionRef = db.collection(Constants.FStore.userCollectionName)
        collectionRef.whereField(Constants.FStore.userPseudoField, isEqualTo: field).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()[Constants.FStore.userPseudoField] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
    
    /// Delete a firebase account
    func deleteAccount(completion: @escaping DeleteAccountCompletion) {
        guard let currentUser = Auth.auth().currentUser else {
            return}
        currentUser.delete { error in
            if error != nil {
                print("An error happened")
                completion(false)
            } else {
                print("successfully deleted")
                completion(true)
            }
        }
    }
}
    
