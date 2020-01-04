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
        self.tabBarController?.navigationItem.hidesBackButton = true
        messagesTableView.dataSource = self
        messagesTableView.register(UINib(nibName: K.messageCellNibName, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func loadMessages() {
        db.collection(K.FStore.messagesCollectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
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
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.messagesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        guard let userUid = Auth.auth().currentUser?.uid, let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email else {
            return
        }
        
        db.collection(K.FStore.messagesCollectionName).addDocument(data: [
            K.FStore.senderField: messageSender,
            K.FStore.bodyField: messageBody,
            K.FStore.dateField: Date().timeIntervalSince1970,
            K.FStore.userUidField: userUid
        ]) { (error) in
                guard let e = error else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
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
        let message = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.messageCellIdentifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell()}
        
        cell.messageLabel.text = message.body
        
        guard message.sender == Auth.auth().currentUser?.email else {
            cell.leftAvatarImageView.isHidden = false
            cell.rightAvatarImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            cell.messageLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return cell }
    
        cell.leftAvatarImageView.isHidden = true
        cell.rightAvatarImageView.isHidden = false
        cell.messageBubble.backgroundColor = #colorLiteral(red: 0.08918375522, green: 0.2295971513, blue: 0.2011210024, alpha: 1)
        cell.messageLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
}
