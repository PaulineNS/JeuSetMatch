//
//  SearchViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 21/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        messagesTableView.register(UINib(nibName: K.messageCellNibName, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String else { return }
                    let newMessage = Message(sender: messageSender, body: messageBody)
                    self.messages.append(newMessage)
                    DispatchQueue.main.async {
                        self.messagesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email else {
            return
        }
        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.senderField : messageSender,
            K.FStore.bodyField : messageBody]) { (error) in
                guard let e = error else {
                    print("Successfully saved data.")
                    return
                }
                print("There was an issue saving data to firestore, \(e)")
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}


extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.messageCellIdentifier, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.messageLabel.text = messages[indexPath.row].body
        return cell
    }
}
