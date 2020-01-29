//
//  MeessagesViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 05/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

final class MessagesViewController: UIViewController {
    
    var conversationUseCase: ConversationUseCase?
    var userUseCase: UserUseCase?
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    private var messages = [MessageObject]()
    private var messagesDictionary = [String : MessageObject]()
    let customLoader = CustomLoader()
    
    
    // MARK: - Outlets
    
    @IBOutlet private weak var messagesTableView: UITableView!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customLoader.setAlpha = 0.5
        customLoader.gifName = "ball"
        customLoader.viewColor = UIColor.gray
        
        let firestoreConversation = FirestoreConversationService()
        self.conversationUseCase = ConversationUseCase(message: firestoreConversation)
        
        let firestoreUser = FirestoreUserService()
        self.userUseCase = UserUseCase(user: firestoreUser)
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.register(UINib(nibName: K.messagesCellNibName, bundle: nil), forCellReuseIdentifier: K.messagesCellIdentifier)
        observeUserMessages()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.MessagesToChatSegue else {return}
        guard let chatVc = segue.destination as? ChatViewController else {return}
        chatVc.user = currentUser
    }
    
    // MARK: - Methods
    
    private func observeUserMessages() {
        customLoader.showLoaderView()
        conversationUseCase?.observeUserMessages { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let message):
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
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TableView

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
        
        userUseCase?.fetchPartnerUser(chatPartnerId: chatPartnerId) { (result) in
            switch result {
            case .success(let partnerUser) :
                self.currentUser = partnerUser
                self.performSegue(withIdentifier: K.MessagesToChatSegue, sender: nil)
            case .failure(let error) :
                print(error.localizedDescription)
            case .none:
                return
            }
        }
    }
}


