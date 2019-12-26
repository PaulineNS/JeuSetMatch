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
    
    var messages: [Message] = [
      //  Message(sender: "1@2.fr", body: "Hey!"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        messagesTableView.register(UINib(nibName: K.messageCellNibName, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)
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
        cell.textLabel?.text = messages[indexPath.row].body
        return cell
    }
}
