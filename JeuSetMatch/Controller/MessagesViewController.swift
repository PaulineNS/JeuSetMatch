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

    
//    func loadConversations() {
//
//        db.collection(K.FStore.messagesCollectionName)
//            .whereField(K.FStore.userUidField, isEqualTo: Auth.auth().currentUser?.uid as Any)
//            .addSnapshotListener { (querySnapshot, error) in
//            self.messages = []
//            if let e = error {
//                print("There was an issue retrieving data from Firestore. \(e)")
//            } else {
//                guard let snapshotDocuments = querySnapshot?.documents else {return}
//                for doc in snapshotDocuments {
//                    let data = doc.data()
//                    guard let messageSender = data[K.FStore.userPseudoField] as? String, let messageBody = data[K.FStore.bodyField] as? String, let messageReceiver = data[K.FStore.receiverPseudoField] as? String else {
//                        print("pb sur messagevc")
//                        return }
//                    let messages = Message(senderPseudo: messageSender, body: messageBody, receiverPseudo: messageReceiver)
//                    self.conversations.append(messages)
//                    DispatchQueue.main.async {
//                        self.messagesTableView.reloadData()
//                    }
//                }
//            }
//        }
//    }
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
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//         let message = messages[indexPath.row]
//         print(message)
//
//         guard let chatPartnerId = message.chatPartnerId() else { return }
//
//         db.collection("users").document(chatPartnerId).getDocument { (DocumentSnapshot, error) in
//             if error != nil {
//                print(error as Any)
//             } else {
//                print(DocumentSnapshot as Any)
//                 guard let dictionary = DocumentSnapshot?.data() else { return }
//
////                let user = User(pseudo: dictionary[K.FStore.userPseudoField] as? String, image: dictionary[K.FStore.userPictureField] as? Data, sexe: dictionary[K.FStore.userGenderField] as? String, level: dictionary[K.FStore.userLevelField] as? String, city: dictionary[K.FStore.userCityField] as? String, birthDate: dictionary[K.FStore.userAgeField] as? String, uid: chatPartnerId)
// self.showChatControllerForUser(user: user)
//                //performSegue
//
//             }
//         }
//    }
    
}


//class MessageController: UITableViewController {
    
//    let db = Firestore.firestore()
//    var messages = [Message]()
//    var messagesDictionary = [String : Message]()
//
//
//    //FIXME:
//    func observeUserMessages() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        db.collection("user-messages").document(uid).collection("users").addSnapshotListener { (DocumentSnapshot, error) in
//
//            DocumentSnapshot?.documentChanges.forEach({ (diff) in
//
//                let toId = diff.document.documentID
//            self.db.collection("user-messages").document(uid).collection("users").document(toId).collection("messages").addSnapshotListener { (querySnapshot, error) in
//
//                        querySnapshot?.documentChanges.forEach({ (diffInMessages) in
//
//                            let messageID = diffInMessages.document.documentID
//
//                            self.db.collection("messages").document(messageID).getDocument(completion: { (document, error) in
//
//                                guard let dataFromDocument = document?.data() else { return }
//                                let message = Message(dictionary: dataFromDocument)
//
//
//                                if let chatPartnerId = message.chatPartnerId() {
//                                    self.messagesDictionary[chatPartnerId] = message
//                                    self.messages = Array(self.messagesDictionary.values)
//
//                                    self.messages.sort(by: { (message1, message2) -> Bool in
//                                        return Int32(truncating: message1.timestamp!) > Int32(truncating: message2.timestamp!)
//
//                                    })
//                                }
//                                DispatchQueue.main.async {
//                                    print("reload")
//                                    self.tableView.reloadData()
//                                }
//                            })
//                        })
//                }
//            })
//        }
//    }
//
//    var timer : Timer?
//    //FIXME: Add timer
//    @objc func handleReloadTable() {
//        DispatchQueue.main.async {
//            print("reload")
//            self.tableView.reloadData()
//        }
//    }
//
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
//
//        let message = messages[indexPath.row]
//        cell.message = message
//
//
//        return cell
//    }
    

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       let message = messages[indexPath.row]
//        print(message)
//
//        guard let chatPartnerId = message.chatPartnerId() else { return }
//
//        let ref = Firestore.firestore().collection("users").document(chatPartnerId)
//        ref.getDocument { (DocumentSnapshot, error) in
//            if error != nil {
//                print(error)
//            } else {
//                print(DocumentSnapshot)
//                guard let dictionary = DocumentSnapshot?.data() else { return }
//                let user = User()
//
//                user.id = chatPartnerId
//                user.userName = dictionary["userName"] as? String
//                user.email = dictionary["email"] as? String
//                user.profileImageUrl = dictionary["profileImageUrl"] as? String
//
//
//                self.showChatControllerForUser(user: user)
//
//            }
//        }
//    }
    
//    @objc func handleNewMessage() {
//        let newMessageController = NewMessageController()
//        newMessageController.messagesController = self
//        let navController = UINavigationController(rootViewController: newMessageController)
//        present(navController, animated: true, completion: nil)
//    }
//
//    func checkIfUserIsLoggedIn() {
//        if Auth.auth().currentUser?.uid == nil {
//            perform(#selector(handleLogout),with: nil, afterDelay: 0)
//        } else {
//            fetchUserAndSetupNavBarTitle()
//        }
//    }
    
//    func fetchUserAndSetupNavBarTitle() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let docRef = Firestore.firestore().collection("users").document(uid)
//        docRef.getDocument { (document, error) in
//            if let dictionary = document?.data() {
//
//                let user = User()
//                user.userName = dictionary["userName"] as? String
//                user.email = dictionary["email"] as? String
//                user.profileImageUrl = dictionary["profileImageUrl"] as? String
//
//                self.setupNavBarWithUser(user: user)
//
//            } else {
//                print("Document is not exist")
//            }
//        }
//    }
    
//    func setupNavBarWithUser(user: User) {
//
//
//        messages.removeAll()
//        messagesDictionary.removeAll()
//
//        tableView.reloadData()
//
//        observeUserMessages()
//
//        let titleView = UIView()
//        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//
//        titleView.isUserInteractionEnabled = true
//
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        titleView.addSubview(containerView)
//
//        let profileImageView = UIImageView()
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.layer.cornerRadius = 20
//        profileImageView.clipsToBounds = true
//        if let profileImageUrl = user.profileImageUrl {
//            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
//        }
//
//        containerView.addSubview(profileImageView)
//
//        //need x,y,width,height anchors
//        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        let nameLabel = UILabel()
//
//        containerView.addSubview(nameLabel)
//        nameLabel.text = user.userName
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        //need x,y,width,height anchors
//        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
//
//        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
//
//
//        self.navigationItem.titleView = titleView
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
//
//     }
    
//    @objc func showChatControllerForUser(user: User) {
//        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLogController.user = user
//        navigationController?.pushViewController(chatLogController, animated: true)
//
//    }
    
//    @objc func handleLogout() {
//
//        do {
//          try Auth.auth().signOut()
//        } catch {
//            print(error)
//        }
//
//        let loginController = LoginController()
//        loginController.messagesController = self
//        present(loginController, animated: true, completion: nil)
//    }
    
//}

