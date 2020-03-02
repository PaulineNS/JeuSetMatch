//
//  MeessagesViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 05/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

final class MessagesViewController: UIViewController {
    
    // MARK: - Instensiation
    
    private let customLoader = CustomLoader()
    private let firestoreUser = FirestoreUserService()
    private let firestoreConversation = FirestoreConversationService()

    // MARK: - Variables
    
    private var userSelected: UserObject?
    private var messages = [MessageObject]()
    private var messagesDictionary = [String : MessageObject]()
    lazy private var userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
    lazy private var conversationUseCase: ConversationUseCase = ConversationUseCase(message: firestoreConversation)

    
    // MARK: - Outlets
    
    @IBOutlet private weak var messagesTableView: UITableView! { didSet { messagesTableView.tableFooterView = UIView() }}
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        messagesTableView.register(UINib(nibName: Constants.Cell.messagesCellNibName, bundle: nil), forCellReuseIdentifier: Constants.Cell.messagesCellIdentifier)
        observeUserMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Messages"
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segue.messagesToChatSegue else {return}
        guard let chatVc = segue.destination as? ChatViewController else {return}
        chatVc.receiverUser = userSelected
    }
    
    // MARK: - Methods
    
    /// Manage to fetch old and new messages
    private func observeUserMessages() {
        customLoader.showLoaderView()
        conversationUseCase.observeUserMessages { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let message):
                self.removeFakeMessage()
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return Int32(truncating: message1.timestamp!) > Int32(truncating: message2.timestamp!)
                    })
                }
                DispatchQueue.main.async {
                    self.messagesTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                self.messages = []
                DispatchQueue.main.async {
                    self.messagesTableView.reloadData()
                }
            }
        }
    }
    
    private func removeFakeMessage() {
        if let index = messages.firstIndex(of: MessageObject(dictionary: ["" : ""])) {
            messages.remove(at: index)
        }
    }
}

// MARK: - TableView

extension MessagesViewController : UITableViewDelegate, UITableViewDataSource {
    
    /// Number of cells in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    /// Define tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.messagesCellIdentifier, for: indexPath) as? MessagesTableViewCell else { return UITableViewCell()}
        cell.message = message
        cell.backgroundColor = .clear
        return cell
    }
    
    /// Actions after a cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else { return }
        userUseCase.fetchPartnerUser(chatPartnerId: chatPartnerId) { (result) in
            switch result {
            case .success(let partnerUser) :
                self.userSelected = partnerUser
                self.performSegue(withIdentifier: Constants.Segue.messagesToChatSegue, sender: nil)
            case .failure(let error) :
                print(error.localizedDescription)
            case .none:
                return
            }
        }
    }
    
    /// Get in shape the tableView footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "sad")
        view.addSubview(imageView)
        let label = UILabel()
        label.text = "Vous n'avez pas encore de message"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        view.addSubview(label)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.width.equalTo(200)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20.0)
            make.right.equalTo(view).offset(-15.0)
            make.left.equalTo(view).offset(15.0)
        }
        return view
    }
    
    /// Display the tableView footer depending the number of elements in messages
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return messages.isEmpty ? tableView.bounds.size.height : 0
    }
}
