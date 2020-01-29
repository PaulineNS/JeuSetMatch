//
//  FirestoreService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 16/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import Firebase

enum FireStoreError: Error {
    case noData
}

class FirestoreService {
    
    private let db = Firestore.firestore()
    let currentUserUid = Auth.auth().currentUser?.uid
    
    func deleteAccount() {
        guard let currentUser = Auth.auth().currentUser else {
            print("pb unique id")
            return}
        currentUser.delete { error in
          if let error = error {
            print("An error happened")
          } else {
            print("successfully deleted")
          }
        }
    }
    
    func checkPseudoDisponibility(field: String, completion: @escaping (Bool) -> Void) {
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
    
    
    func sendMessage(withProperties: [String : Any], toId: String) {
        let ref = db.collection("messages").document()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser?.uid
        var values : [String : Any] = ["toId" : toId as Any, "fromId" : fromId as Any, "timestamp" : timestamp]
        withProperties.forEach {( values[$0] = $1 )}
        ref.setData(values) { (error) in
            if error != nil {
                print(error as Any)
            } else {
                print("success")
                
                let messageId = ref.documentID
                //step 1
                let userRef = self.db.collection("user-messages").document(fromId!).collection("users").document(toId)
                userRef.setData([toId : 1])
                //step 2
                let userMessageRef =  self.db.collection("user-messages").document(fromId!).collection("users").document(toId).collection("messages").document(messageId)
                
                userMessageRef.setData([messageId : 1])
                
                //step 1
                let recipienUserRef = self.db.collection("user-messages").document(toId).collection("users").document(fromId!)
                recipienUserRef.setData([fromId! : 1])
                
                let recipienUserMessageRef = self.db.collection("user-messages").document(toId).collection("users").document(fromId!).collection("messages").document(messageId)
                
                recipienUserMessageRef.setData([messageId : 1])
            }
        }
    }
    
    func setupNameAndProfileImage(id: String, completion: @escaping (Result<[String:Any], Error>) -> Void) {
        db.collection("users").document("\(id)").getDocument(source: .default) { (snapshot, error) in
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
    
    func updateUserInformation(userAge: String, userCity: String, userGender: String, userLevel: String, userName: String, userImage: Data) {
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData([
            "userAge": userAge,
            "userCity": userCity,
            "userGender": userGender,
            "userImage": userImage,
            "userLevel": userLevel,
            "userName": userName
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

    



 
