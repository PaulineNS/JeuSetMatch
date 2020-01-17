//
//  FirestoreService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 16/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import Firebase

class FirestoreService {
    
    private let db = Firestore.firestore()
    let currentUserUid = Auth.auth().currentUser?.uid

    enum FireStoreError: Error {
        case noData
    }
    
    func createUser(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
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
                    let currentUser = User(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: data["userUid"] as? String)
                    completion(.success(currentUser))
                    }
                }
            }
        }
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                guard let snapchotDocument = querySnapshot?.documents else {return}
                for document in snapchotDocument {
                    let data = document.data()
                    let user = User(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: document.documentID)
                    completion(.success(user))
                    }
                    
                }
            }
        }

    func observeUserMessages(completion: @escaping (Result<Message, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("user-messages").document(uid).collection("users").addSnapshotListener { (DocumentSnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                
                DocumentSnapshot?.documentChanges.forEach({ (diff) in
                    
                    let toId = diff.document.documentID
                    self.db.collection("user-messages").document(uid).collection("users").document(toId).collection("messages").addSnapshotListener { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            completion(.failure(FireStoreError.noData))
                            return
                        } else {
                            querySnapshot?.documentChanges.forEach({ (diffInMessages) in
                                
                                let messageID = diffInMessages.document.documentID
                                
                                self.db.collection("messages").document(messageID).getDocument(completion: { (document, error) in
                                    if let error = error {
                                        print("Error getting documents: \(error)")
                                        completion(.failure(FireStoreError.noData))
                                        return
                                    } else {
                                        guard let dataFromDocument = document?.data() else { return }
                                        let message = Message(dictionary: dataFromDocument)
                                        completion(.success(message))
                                    }
                                })
                            })
                        }
                    }
                })
            }
        }
    }
    
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping (Result<User, Error>) -> Void){
        db.collection("users").document(chatPartnerId).getDocument { (DocumentSnapshot, error) in
            if error != nil {
                print("error, \(error!)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                print(DocumentSnapshot as Any)
                guard let dictionary = DocumentSnapshot?.data() else { return }
                
                let user = User(pseudo: dictionary["userName"] as? String, image: dictionary["userImage"] as? Data, sexe: dictionary["userGender"] as? String, level: dictionary["userLevel"] as? String, city: dictionary["userCity"] as? String, birthDate: dictionary["userAge"] as? String, uid: chatPartnerId)
                completion(.success(user))
            }
        }
    }
    
    func observeUserChatMessages(toId: String, completion: @escaping (Result<Message, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("user-messages").document(uid).collection("users").document(toId).collection("messages").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                snapshot?.documentChanges.forEach({ (diff) in
                    let messageId = diff.document.documentID
                    self.db.collection("messages").document(messageId).getDocument(completion: { (document, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            completion(.failure(FireStoreError.noData))
                            return
                        } else {
                            guard let dictionary = document?.data() else { return }
                            
                            let message = Message(dictionary: dictionary)
                            print("we fetched this message \(message.text ?? "")")
                            completion(.success(message))
                        }
                    })
                })
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
}
    



 
