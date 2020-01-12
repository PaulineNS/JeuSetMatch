//
//  SearchViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 21/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var receiverPseudo: UINavigationItem!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.hidesBackButton = true
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: K.chatCellNibName, bundle: nil), forCellReuseIdentifier: K.chatCellIdentifier)
        receiverPseudo.title = user?.pseudo
//        observeMessages()
    }
    
    var user : User? {
        didSet {
            receiverPseudo.title = user?.pseudo
//            navigationItem.title = user?.pseudo
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    @IBAction func sendPressed(_ sender: UIButton) {
        let properties : [String : Any] = ["text" : chatTextField.text!]
        sendMessageWithProperties(properties: properties)
    }
    
    
    private func sendMessageWithProperties(properties: [String : Any]) {
        
        let ref = db.collection("messages").document()
        let toId = user?.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser?.uid
        
        var values : [String : Any] = ["toId" : toId as Any, "fromId" : fromId as Any, "timestamp" : timestamp]
        
        properties.forEach {( values[$0] = $1 )}
        
        
        ref.setData(values) { (error) in
            if error != nil {
                print(error as Any)
            } else {
                print("success")
                
                let messageId = ref.documentID
                //step 1
                let userRef = self.db.collection("user-messages").document(fromId!).collection("users").document(toId!)
                userRef.setData([toId! : 1])
                //step 2
                let userMessageRef =  self.db.collection("user-messages").document(fromId!).collection("users").document(toId!).collection("messages").document(messageId)
                
                userMessageRef.setData([messageId : 1])
                
                //step 1
                let recipienUserRef = self.db.collection("user-messages").document(toId!).collection("users").document(fromId!)
                recipienUserRef.setData([fromId! : 1])
                
                let recipienUserMessageRef = self.db.collection("user-messages").document(toId!).collection("users").document(fromId!).collection("messages").document(messageId)
                
                recipienUserMessageRef.setData([messageId : 1])
                
                self.chatTextField.text = ""
            }
        }
    }
    
    //MARK: ObserveMessages
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.uid else { return }
        db.collection("user-messages")
            .document(uid)
            .collection("users")
            .document(toId)
            .collection("messages")
            .addSnapshotListener { (snapshot, error) in
                snapshot?.documentChanges.forEach({ (diff) in
                    
                    let messageId = diff.document.documentID
                    
                    self.db.collection("messages")
                        .document(messageId)
                        .getDocument(completion: { (document, error) in
                            
                            guard let dictionary = document?.data() else { return }
                            
                            let message = Message(dictionary: dictionary)
                            
                            print("we fetched this message \(message.text ?? "")")
                            if message.chatPartnerId() == self.user?.uid {
                                print("what")
                                self.messages.append(message)
                                
                                self.messages.sort { (message1, message2) -> Bool in
                                    return Int32(truncating: message1.timestamp!) < Int32(truncating: message2.timestamp!)
                                }
                                
                                print(self.messages)
                                
                                DispatchQueue.main.async {
                                    self.chatTableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                }
                            }
                        })
                })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.chatCellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell()}
        
        cell.messageLabel.text = message.text
        
        guard message.toId == Auth.auth().currentUser?.uid else {
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
