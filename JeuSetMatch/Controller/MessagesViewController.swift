//
//  MeessagesViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 05/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    let db = Firestore.firestore()
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.register(UINib(nibName: K.messagesCellNibName, bundle: nil), forCellReuseIdentifier: K.messagesCellIdentifier)
        observeUserMessages()
//        loadConversations()
        print("messagesvc", currentUser?.birthDate as Any)
        print("messagesvc", currentUser?.city as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("messagesvc", currentUser?.birthDate as Any)
        print("messagesvc", currentUser?.city as Any)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.MessagesToChatSegue else {return}
        guard let chatVc = segue.destination as? ChatViewController else {return}
        chatVc.user = currentUser
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("user-messages").document(uid).collection("users").addSnapshotListener { (DocumentSnapshot, error) in
            
            DocumentSnapshot?.documentChanges.forEach({ (diff) in
                
                let toId = diff.document.documentID
            self.db.collection("user-messages").document(uid).collection("users").document(toId).collection("messages").addSnapshotListener { (querySnapshot, error) in
                
                        querySnapshot?.documentChanges.forEach({ (diffInMessages) in
                        
                            let messageID = diffInMessages.document.documentID
                            
                            self.db.collection("messages").document(messageID).getDocument(completion: { (document, error) in
                                
                                guard let dataFromDocument = document?.data() else { return }
                                let message = Message(dictionary: dataFromDocument)
                                
                                
                                if let chatPartnerId = message.chatPartnerId() {
                                    self.messagesDictionary[chatPartnerId] = message
                                    self.messages = Array(self.messagesDictionary.values)
                                    
                                    self.messages.sort(by: { (message1, message2) -> Bool in
                                        return Int32(truncating: message1.timestamp!) > Int32(truncating: message2.timestamp!)
                                        
                                    })
                                }
                                DispatchQueue.main.async {
                                    print("reload")
                                    self.messagesTableView.reloadData()
                                }
                            })
                        })
                }
            })
        }
    }
}

extension MessagesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.messagesCellIdentifier, for: indexPath) as? MessagesTableViewCell else { return UITableViewCell()}
        
        cell.message = message
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                 let message = messages[indexPath.row]
                 print(message)
        
                 guard let chatPartnerId = message.chatPartnerId() else { return }
        
                 db.collection("users").document(chatPartnerId).getDocument { (DocumentSnapshot, error) in
                     if error != nil {
                        print(error as Any)
                     } else {
                        print(DocumentSnapshot as Any)
                         guard let dictionary = DocumentSnapshot?.data() else { return }
        
                        let user = User(pseudo: dictionary["userName"] as? String, image: dictionary["userImage"] as? Data, sexe: dictionary["userGender"] as? String, level: dictionary["userLevel"] as? String, city: dictionary["userCity"] as? String, birthDate: dictionary["userAge"] as? String, uid: chatPartnerId)
                        self.currentUser = user
                        
                        self.performSegue(withIdentifier: K.MessagesToChatSegue, sender: nil)
            }
        }
    }
}


