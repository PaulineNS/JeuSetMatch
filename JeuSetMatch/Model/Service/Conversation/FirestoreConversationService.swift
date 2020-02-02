//
//  FirestoreConversationService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Firebase

class FirestoreConversationService: ConversationUseCaseOutput {
    
    private let db = Firestore.firestore()
    
    func observeUserMessages(completion: @escaping ConversationCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection(Constants.FStore.userMessagesCollectionName).document(uid).collection(Constants.FStore.userCollectionName).addSnapshotListener { (DocumentSnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                if DocumentSnapshot?.isEmpty == true {
                    completion(nil)
                }
                DocumentSnapshot?.documentChanges.forEach({ (diff) in
                    
                    let toId = diff.document.documentID
                    self.db.collection(Constants.FStore.userMessagesCollectionName).document(uid).collection(Constants.FStore.userCollectionName).document(toId).collection(Constants.FStore.messagesCollectionName).addSnapshotListener { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            completion(.failure(FireStoreError.noData))
                            return
                        } else {
                            querySnapshot?.documentChanges.forEach({ (diffInMessages) in
                                
                                let messageID = diffInMessages.document.documentID
                                
                                self.db.collection(Constants.FStore.messagesCollectionName).document(messageID).getDocument(completion: { (document, error) in
                                    if let error = error {
                                        print("Error getting documents: \(error)")
                                        completion(.failure(FireStoreError.noData))
                                        return
                                    } else {
                                        guard let dataFromDocument = document?.data() else { return }
                                        let message = MessageObject(dictionary: dataFromDocument)
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
    
    func observeUserChatMessages(toId: String, completion: @escaping ConversationCompletion) {
        guard let uid = Auth.auth().currentUser?.uid else {return }
        db.collection(Constants.FStore.userMessagesCollectionName).document(uid).collection(Constants.FStore.userCollectionName).document(toId).collection(Constants.FStore.messagesCollectionName).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(FireStoreError.noData))
                return
            } else {
                snapshot?.documentChanges.forEach({ (diff) in
                    let messageId = diff.document.documentID
                    self.db.collection(Constants.FStore.messagesCollectionName).document(messageId).getDocument(completion: { (document, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            completion(.failure(FireStoreError.noData))
                            return
                        } else {
                            guard let dictionary = document?.data() else { return }
                            
                            let message = MessageObject(dictionary: dictionary)
                            print("We fetched this message \(message.text ?? "")")
                            completion(.success(message))
                        }
                    })
                })
            }
        }
    }
}
