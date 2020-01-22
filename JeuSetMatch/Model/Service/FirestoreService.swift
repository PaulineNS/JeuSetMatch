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

//    func createUser(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping (Result<UserObject, Error>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            if error != nil {
//                print("error, \(error!)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//                guard let uid = Auth.auth().currentUser?.uid else {return}
//                let data = ["userAge": userAge,
//                            "userGender": userGender,
//                            "userLevel": userLevel,
//                            "userCity": userCity,
//                            "userName": userName,
//                            "userImage": userImage,
//                            "userUid": uid]
//                self.db.collection("users").document("\(uid)").setData(data) { (error) in
//                    if error != nil {
//                        print(error!)
//                        return
//                    }
//                    let currentUser = UserObject(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: data["userUid"] as? String)
//                    completion(.success(currentUser))
//                    }
//                }
//            }
//        }
    
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
    
//    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                print("error, \(error)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//                guard let authDataResult = authResult else {return}
//                completion(.success(authDataResult))
//            }
//        }
//    }
    
//    func fetchUser(completion: @escaping (Result<UserObject, Error>) -> Void) {
//        db.collection("users").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//                guard let snapchotDocument = querySnapshot?.documents else {return}
//                for document in snapchotDocument {
//                    let data = document.data()
//                    let user = UserObject(pseudo: data["userName"] as? String, image: data["userImage"] as? Data, sexe: data["userGender"] as? String, level: data["userLevel"] as? String, city: data["userCity"] as? String, birthDate: data["userAge"] as? String, uid: document.documentID)
//                    completion(.success(user))
//                    }
//                }
//            }
//        }

//    func observeUserMessages(completion: @escaping (Result<MessageObject, Error>) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        db.collection("user-messages").document(uid).collection("users").addSnapshotListener { (DocumentSnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//
//                DocumentSnapshot?.documentChanges.forEach({ (diff) in
//
//                    let toId = diff.document.documentID
//                    self.db.collection("user-messages").document(uid).collection("users").document(toId).collection("messages").addSnapshotListener { (querySnapshot, error) in
//                        if let error = error {
//                            print("Error getting documents: \(error)")
//                            completion(.failure(FireStoreError.noData))
//                            return
//                        } else {
//                            querySnapshot?.documentChanges.forEach({ (diffInMessages) in
//
//                                let messageID = diffInMessages.document.documentID
//
//                                self.db.collection("messages").document(messageID).getDocument(completion: { (document, error) in
//                                    if let error = error {
//                                        print("Error getting documents: \(error)")
//                                        completion(.failure(FireStoreError.noData))
//                                        return
//                                    } else {
//                                        guard let dataFromDocument = document?.data() else { return }
//                                        let message = MessageObject(dictionary: dataFromDocument)
//                                        completion(.success(message))
//                                    }
//                                })
//                            })
//                        }
//                    }
//                })
//            }
//        }
//    }
    
//    func fetchPartnerUser(chatPartnerId: String, completion: @escaping (Result<UserObject, Error>) -> Void){
//        db.collection("users").document(chatPartnerId).getDocument { (DocumentSnapshot, error) in
//            if error != nil {
//                print("error, \(error!)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//                print(DocumentSnapshot as Any)
//                guard let dictionary = DocumentSnapshot?.data() else { return }
//
//                let user = UserObject(pseudo: dictionary["userName"] as? String, image: dictionary["userImage"] as? Data, sexe: dictionary["userGender"] as? String, level: dictionary["userLevel"] as? String, city: dictionary["userCity"] as? String, birthDate: dictionary["userAge"] as? String, uid: chatPartnerId)
//                completion(.success(user))
//            }
//        }
//    }
    
//    func observeUserChatMessages(toId: String, completion: @escaping (Result<MessageObject, Error>) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        db.collection("user-messages").document(uid).collection("users").document(toId).collection("messages").addSnapshotListener { (snapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//                snapshot?.documentChanges.forEach({ (diff) in
//                    let messageId = diff.document.documentID
//                    self.db.collection("messages").document(messageId).getDocument(completion: { (document, error) in
//                        if let error = error {
//                            print("Error getting documents: \(error)")
//                            completion(.failure(FireStoreError.noData))
//                            return
//                        } else {
//                            guard let dictionary = document?.data() else { return }
//
//                            let message = MessageObject(dictionary: dictionary)
//                            print("we fetched this message \(message.text ?? "")")
//                            completion(.success(message))
//                        }
//                    })
//                })
//            }
//        }
//    }
    
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
    
    
//    func fetchUserInformationsDependingUid(userUid: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
////        self.userInformations = []
//        db.collection("users").whereField("userUid", isEqualTo: userUid).addSnapshotListener { (querySnapshot, error) in
//            if let error = error {
//                print("There was an issue retrieving data from Firestore\(error)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//                guard let snapshotDocuments = querySnapshot?.documents else {return}
//                for doc in snapshotDocuments {
//                    let data = doc.data()
//                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
//                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
//                    completion(.success(user))
//                }
//            }
//        }
//    }
    
    func updateUserInformation(userCity: String, userGender: String, userLevel: String, userName: String) {
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData([
            //            "userAge": "",
            "userCity": userCity,
            "userGender": userGender,
            //            "userImage": "",
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

    



 
