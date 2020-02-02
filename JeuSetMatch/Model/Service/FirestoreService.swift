//
//  FirestoreService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 16/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import Firebase

// MARK: - todo firestore errors

enum FireStoreError: Error {
    case noData
}

class FirestoreService {
    
    // MARK: - Variables

    private let db = Firestore.firestore()
    let currentUserUid = Auth.auth().currentUser?.uid
    let currentUser = Auth.auth().currentUser
    
    // MARK: - Methods

    func deleteAccount() {
        guard let currentUser = Auth.auth().currentUser else {
            return}
        currentUser.delete { error in
            if error != nil {
                print("An error happened")
            } else {
                print("successfully deleted")
            }
        }
    }
    
    func checkPseudoDisponibility(field: String, completion: @escaping (Bool) -> Void) {
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
    
    
    func sendMessage(withProperties: [String : Any], toId: String) {
        let ref = db.collection(Constants.FStore.messagesCollectionName).document()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser?.uid
        var values : [String : Any] = [Constants.FStore.toIdMessage: toId as Any, Constants.FStore.fromIdMessage: fromId as Any, Constants.FStore.timestampMessage: timestamp]
        withProperties.forEach {( values[$0] = $1 )}
        ref.setData(values) { (error) in
            if error != nil {
                print(error as Any)
            } else {
                print("success")
                
                let messageId = ref.documentID
                //step 1
                let userRef = self.db.collection(Constants.FStore.userMessagesCollectionName).document(fromId!).collection(Constants.FStore.userCollectionName).document(toId)
                userRef.setData([toId : 1])
                //step 2
                let userMessageRef =  self.db.collection(Constants.FStore.userMessagesCollectionName).document(fromId!).collection(Constants.FStore.userCollectionName).document(toId).collection(Constants.FStore.messagesCollectionName).document(messageId)
                
                userMessageRef.setData([messageId : 1])
                
                //step 1
                let recipienUserRef = self.db.collection(Constants.FStore.userMessagesCollectionName).document(toId).collection(Constants.FStore.userCollectionName).document(fromId!)
                recipienUserRef.setData([fromId! : 1])
                
                let recipienUserMessageRef = self.db.collection(Constants.FStore.userMessagesCollectionName).document(toId).collection(Constants.FStore.userCollectionName).document(fromId!).collection(Constants.FStore.messagesCollectionName).document(messageId)
                
                recipienUserMessageRef.setData([messageId : 1])
            }
        }
    }
    
    func setupNameAndProfileImage(id: String, completion: @escaping (Result<[String:Any], Error>) -> Void) {
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
    
    func updateUserInformation(userAge: String, userCity: String, userGender: String, userLevel: String, userImage: Data) {
        
        db.collection(Constants.FStore.userCollectionName).document(Auth.auth().currentUser?.uid ?? "").updateData([
            Constants.FStore.userAgeField: userAge,
            Constants.FStore.userCityField: userCity,
            Constants.FStore.userGenderField: userGender,
            Constants.FStore.userPictureField: userImage,
            Constants.FStore.userLevelField: userLevel,
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func logOut(){
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

    



 
