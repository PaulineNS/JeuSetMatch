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
    let currentUserUid = Auth.auth().currentUser?.uid

    
    func fetchUserWithoutFilters(completion: @escaping UserCompletion) {
        db.collection(Constants.FStore.userCollectionName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapchotDocument = querySnapshot?.documents else {return}
                if snapchotDocument.isEmpty {
                        completion(nil)
                }
                for document in snapchotDocument {
                    let data = document.data()
                    let user = UserObject(pseudo: data[Constants.FStore.userPseudoField] as? String, image: data[Constants.FStore.userPictureField] as? Data, sexe: data[Constants.FStore.userGenderField] as? String, level: data[Constants.FStore.userLevelField] as? String, city: data[Constants.FStore.userCityField] as? String, birthDate: data[Constants.FStore.userAgeField] as? String, uid: document.documentID)
                    completion(.success(user))
                }
            }
        }
    }
    
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping UserCompletion){
        db.collection(Constants.FStore.userCollectionName).document(chatPartnerId).getDocument { (DocumentSnapshot, error) in
            if error != nil {
                print("error, \(error!)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                print(DocumentSnapshot as Any)
                guard let dictionary = DocumentSnapshot?.data() else { return }
                
                let user = UserObject(pseudo: dictionary[Constants.FStore.userPseudoField] as? String, image: dictionary[Constants.FStore.userPictureField] as? Data, sexe: dictionary[Constants.FStore.userGenderField] as? String, level: dictionary[Constants.FStore.userLevelField] as? String, city: dictionary[Constants.FStore.userCityField] as? String, birthDate: dictionary[Constants.FStore.userAgeField] as? String, uid: chatPartnerId)
                completion(.success(user))
            }
        }
    }
    
    func fetchUserInformationsDependingOneFilter(field1: String, field1value: String, completion: @escaping UserCompletion){
        db.collection(Constants.FStore.userCollectionName).whereField(field1, isEqualTo: field1value).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                if snapshotDocuments.isEmpty {
                        completion(nil)
                }
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data[Constants.FStore.userPseudoField] as? String ,let userGender = data[Constants.FStore.userGenderField] as? String, let userCity = data[Constants.FStore.userCityField] as? String, let userLevel = data[Constants.FStore.userLevelField] as? String, let userPicture = data[Constants.FStore.userPictureField] as? Data, let userBirthDate = data[Constants.FStore.userAgeField] as? String, let userUid = data[Constants.FStore.userUidField] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    
    func fetchUsersInformationsDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, completion: @escaping UserCompletion){
        db.collection(Constants.FStore.userCollectionName).whereField(field1, isEqualTo: field1value).whereField(field2, isEqualTo: field2Value).addSnapshotListener { (querySnapshot, error) in
             if let error = error {
                 print("There was an issue retrieving data from Firestore\(error)")
                 completion(.failure(FireStoreError.noData))
                 return
             } else {
                 guard let snapshotDocuments = querySnapshot?.documents else {return}
                if snapshotDocuments.isEmpty {
                        completion(nil)
                }
                 for doc in snapshotDocuments {
                     let data = doc.data()
                     guard let userPseudo = data[Constants.FStore.userPseudoField] as? String ,let userGender = data[Constants.FStore.userGenderField] as? String, let userCity = data[Constants.FStore.userCityField] as? String, let userLevel = data[Constants.FStore.userLevelField] as? String, let userPicture = data[Constants.FStore.userPictureField] as? Data, let userBirthDate = data[Constants.FStore.userAgeField] as? String, let userUid = data[Constants.FStore.userUidField] as? String else {return}
                     let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                     completion(.success(user))
                 }
             }
         }
     }
    
    func fetchUserInformationsDependingAllFilters(gender: String, city: String, level: String, completion: @escaping UserCompletion) {
                db.collection(Constants.FStore.userCollectionName).whereField(Constants.FStore.userCityField, isEqualTo: city).whereField(Constants.FStore.userGenderField, isEqualTo: gender).whereField(Constants.FStore.userLevelField, isEqualTo: level).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("There was an issue retrieving data from Firestore\(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                if snapshotDocuments.isEmpty {
                        completion(nil)
                }
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data[Constants.FStore.userPseudoField] as? String ,let userGender = data[Constants.FStore.userGenderField] as? String, let userCity = data[Constants.FStore.userCityField] as? String, let userLevel = data[Constants.FStore.userLevelField] as? String, let userPicture = data[Constants.FStore.userPictureField] as? Data, let userBirthDate = data[Constants.FStore.userAgeField] as? String, let userUid = data[Constants.FStore.userUidField] as? String else {return}
                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
                    completion(.success(user))
                }
            }
        }
    }
    
    func setupNameAndProfileImage(id: String, completion: @escaping SetUpCompletion) {
        db.collection(Constants.FStore.userCollectionName).document("\(id)").getDocument(source: .default) { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            }
            if let dictionary = snapshot?.data() {
                completion(.success(dictionary))
            }
        }
    }
    
    func updateUserInformation(userAge: String, userCity: String, userGender: String, userLevel: String, userImage: Data, completion: @escaping updateInformationsCompletion) {
        db.collection(Constants.FStore.userCollectionName).document(Auth.auth().currentUser?.uid ?? "").updateData([
            Constants.FStore.userAgeField: userAge,
            Constants.FStore.userCityField: userCity,
            Constants.FStore.userGenderField: userGender,
            Constants.FStore.userPictureField: userImage,
            Constants.FStore.userLevelField: userLevel,
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(false)
            } else {
                print("Document successfully updated")
                completion(true)
            }
        }
    }
}
