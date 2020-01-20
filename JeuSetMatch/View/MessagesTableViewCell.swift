//
//  MessagesTableViewCell.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 05/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileUserImageView: UIImageView!
    @IBOutlet weak var pseudoUserLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    // MARK: - Variables
    
    var firestoreService = FirestoreService()
    
    var message : MessageObject? {
        didSet {
            setupNameAndProfileImage()
            lastMessageLabel.text = message?.text
            
            let timestamp = message?.timestamp
            let date = Date(timeIntervalSince1970: timestamp as! TimeInterval)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "CEST")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let strDate = dateFormatter.string(from: date)
            timeLabel.text = strDate
        }
    }
    
    // MARK: - Methods
    
    private func setupNameAndProfileImage() {
        if let id = message?.chatPartnerId() {
            firestoreService.setupNameAndProfileImage(id: id) { (result) in
                switch result {
                case .success(let dictionary) :
                    self.pseudoUserLabel.text = dictionary["userName"] as? String
                    if let profileImage = dictionary["userImage"] as? Data {
                        self.profileUserImageView.image = UIImage(data: profileImage)
                    }
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
    }
}






