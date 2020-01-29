//
//  FirestoreUserService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Firebase

class FirestoreUserService: UserUseCaseOutput {
    
    private let db = Firestore.firestore()
    
    
    func fetchUserInformationsDependingOneFilter(field1: String, field1value: String, completion: @escaping UserCompletion){
        db.collection("users").whereField(field1, isEqualTo: field1value).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    
    func fetchUsersInformationsDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        db.collection("users").whereField(field1, isEqualTo: field1value).whereField(field2, isEqualTo: field2Value).addSnapshotListener { (querySnapshot, error) in
             if let error = error {
                 print("There was an issue retrieving data from Firestore\(error)")
                 completion(.failure(FireStoreError.noData))
                 return
             } else {
                 guard let snapshotDocuments = querySnapshot?.documents else {return}
                 for doc in snapshotDocuments {
                     let data = doc.data()
                     guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                     let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                     completion(.success(user))
                 }
             }
         }
     }
    
    
    
    
    
    func fetchUser(completion: @escaping UserCompletion) {
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapchotDocument = querySnapshot?.documents else {return}
                for document in snapchotDocument {
                    let data = document.data()
                    let user = UserObject(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: document.documentID)
                    completion(.success(user))
                }
            }
        }
    }
    
    
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping UserCompletion){
        db.collection("users").document(chatPartnerId).getDocument { (DocumentSnapshot, error) in
            if error != nil {
                print("error, \(error!)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                print(DocumentSnapshot as Any)
                guard let dictionary = DocumentSnapshot?.data() else { return }
                
                let user = UserObject(pseudo: dictionary["userName"] as? String, image: dictionary["userImage"] as? Data, sexe: dictionary["userGender"] as? String, level: dictionary["userLevel"] as? String, city: dictionary["userCity"] as? String, birthDate: dictionary["userAge"] as? String, uid: chatPartnerId)
                completion(.success(user))
            }
        }
    }
    
    
    func fetchUserInformationsDependingUid(userUid: String, completion: @escaping UserCompletion) {
        db.collection("users").whereField("userUid", isEqualTo: userUid).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchUserInformationsDependingFilters(gender: String, city: String, level: String, completion: @escaping UserCompletion) {
                db.collection("users").whereField("userCity", isEqualTo: city).whereField("userGender", isEqualTo: gender).whereField("userLevel", isEqualTo: level).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchUserInformationsDependingLevel(level: String, completion: @escaping UserCompletion){
        db.collection("users").whereField("userLevel", isEqualTo: level).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchUserInformationsDependingCity(city: String, completion: @escaping UserCompletion){
        db.collection("users").whereField("userCity", isEqualTo: city).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchUserInformationsDependingSexe(sexe: String, completion: @escaping UserCompletion){
        db.collection("users").whereField("userGender", isEqualTo: sexe).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }

    func fetchUserInformationsDependingCityAndLevel(level: String, city: String, completion: @escaping UserCompletion){
        db.collection("users").whereField("userCity", isEqualTo: city).whereField("userLevel", isEqualTo: level).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchUserInformationsDependingCityAndSexe(sexe: String, city: String, completion: @escaping UserCompletion){
        db.collection("users").whereField("userCity", isEqualTo: city).whereField("userGender", isEqualTo: sexe).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchUserInformationsDependingSexeAndLevel(sexe: String, level: String, completion: @escaping UserCompletion){
        db.collection("users").whereField("userGender", isEqualTo: sexe).whereField("userLevel", isEqualTo: level).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
}
