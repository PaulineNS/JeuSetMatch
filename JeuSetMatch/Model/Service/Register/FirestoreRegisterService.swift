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
    
    func register(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping RegisterCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print("error, \(error!)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let data = ["userAge": userAge,
                            "userGender": userGender,
                            "userLevel": userLevel,
                            "userCity": userCity,
                            "userName": userName,
                            "userImage": userImage,
                            "userUid": uid]
                self.db.collection("users").document("\(uid)").setData(data) { (error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    let currentUser = UserObject(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: data["userUid"] as? String)
                    completion(.success(currentUser))
                }
            }
        }
    }
    
    func checkPseudoDisponibility(field: String, completion: @escaping CheckPseudoDisponibility) {
        let collectionRef = db.collection("users")
        collectionRef.whereField("userName", isEqualTo: field).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
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
    
