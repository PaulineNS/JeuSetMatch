//
//  SearchViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 21/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class ChatViewController: UIViewController {
    
    let fireStoreService = FirestoreService()
    let firestoreConversation = FirestoreConversationService()
//    var conversationUseCase: ConversationUseCase?
    lazy var conversationUseCase: ConversationUseCase = ConversationUseCase(message: firestoreConversation)

    // MARK: - Variables

    var user : UserObject? {
        didSet {
            receiverPseudo.title = user?.pseudo
            observeMessages()
        }
    }
    
    private var messages = [MessageObject]()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var chatTableView: UITableView!
    @IBOutlet private weak var chatTextField: UITextField!
    @IBOutlet private weak var receiverPseudo: UINavigationItem!
    
    
    // MARK: - Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let firestoreConversation = FirestoreConversationService()
//        self.conversationUseCase = ConversationUseCase(message: firestoreConversation)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: K.chatCellNibName, bundle: nil), forCellReuseIdentifier: K.chatCellIdentifier)
        receiverPseudo.title = user?.pseudo
    }
    
    
    // MARK: - Actions

    @IBAction private func sendPressed(_ sender: UIButton) {
        let properties : [String : Any] = ["text" : chatTextField.text!]
        guard let toId = user?.uid else { return }
        fireStoreService.sendMessage(withProperties: properties, toId: toId)
        self.chatTextField.text = ""
    }
    
    // MARK: - Methods
    
    private func observeMessages() {
        guard let toId = user?.uid else { return }
        print("pourquoi")
//        fireStoreService
        print(conversationUseCase as Any)
        conversationUseCase.observeUserChatMessages(toId: toId) { (result) in
            switch result {
            case .success(let message) :
                guard message.chatPartnerId() == self.user?.uid else {return}
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
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TableView

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return messages.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let message = messages[indexPath.row]
          
          guard let cell = tableView.dequeueReusableCell(withIdentifier: K.chatCellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell()}
          
          cell.messageLabel.text = message.text
          
        guard message.toId == fireStoreService.currentUserUid else {
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
