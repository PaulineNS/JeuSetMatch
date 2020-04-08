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
    
    ///Observe and fetch new user messages
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
    
    ///Observe and fetch new chat  messages
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
    
    ///Send a svae a new message on dataBase
    func sendMessage(withProperties: [String : Any], toId: String, completion: @escaping SendMessageCompletion) {
        let ref = db.collection(Constants.FStore.messagesCollectionName).document()
        let timestamp = Int(NSDate().timeIntervalSince1970)
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        var values : [String : Any] = [Constants.FStore.toIdMessage: toId as Any, Constants.FStore.fromIdMessage: fromId as Any, Constants.FStore.timestampMessage: timestamp]

        withProperties.forEach {( values[$0] = $1 )}
        ref.setData(values) { (error) in
            if error != nil {
                print(error as Any)
                completion(false)
            } else {
                let messageId = ref.documentID
                //step 1
                let userRef = self.db.collection(Constants.FStore.userMessagesCollectionName).document(fromId).collection(Constants.FStore.userCollectionName).document(toId)
                userRef.setData([toId : 1])
                
                //step 2
                let userMessageRef =  self.db.collection(Constants.FStore.userMessagesCollectionName).document(fromId).collection(Constants.FStore.userCollectionName).document(toId).collection(Constants.FStore.messagesCollectionName).document(messageId)
                userMessageRef.setData([messageId : 1])
                
                //step 1
                let recipienUserRef = self.db.collection(Constants.FStore.userMessagesCollectionName).document(toId).collection(Constants.FStore.userCollectionName).document(fromId)
                recipienUserRef.setData([fromId : 1])
                
                let recipienUserMessageRef = self.db.collection(Constants.FStore.userMessagesCollectionName).document(toId).collection(Constants.FStore.userCollectionName).document(fromId).collection(Constants.FStore.messagesCollectionName).document(messageId)
                recipienUserMessageRef.setData([messageId : 1])
                
                completion(true)
            }
        }
    }
}
