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
    var conversations: [Message] = []
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.register(UINib(nibName: K.messagesCellNibName, bundle: nil), forCellReuseIdentifier: K.messagesCellIdentifier)
        loadConversations()
    }
    
    func loadConversations() {
        
        db.collection(K.FStore.messagesCollectionName)
            .whereField(K.FStore.userUidField, isEqualTo: Auth.auth().currentUser?.uid as Any)
            .addSnapshotListener { (querySnapshot, error) in
            self.conversations = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let messageSender = data[K.FStore.userPseudoField] as? String, let messageBody = data[K.FStore.bodyField] as? String, let messageReceiver = data[K.FStore.receiverPseudoField] as? String else { return }
                    let messages = Message(senderPseudo: messageSender, body: messageBody, receiverPseudo: messageReceiver)
                    self.conversations.append(messages)
                    DispatchQueue.main.async {
                        self.messagesTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension MessagesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = conversations[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.messagesCellIdentifier, for: indexPath) as? MessagesTableViewCell else { return UITableViewCell()}
        
        cell.pseudoUserLabel.text = conversation.receiverPseudo
        
        return cell
    }
    
    
}
