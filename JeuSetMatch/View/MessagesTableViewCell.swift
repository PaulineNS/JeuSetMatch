//
//  MessagesTableViewCell.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 05/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var profileUserImageView: UIImageView!
    @IBOutlet weak var pseudoUserLabel: UILabel!
    @IBOutlet weak var lastMessage: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var message : Message? {
        didSet {
            setupNameAndProfileImage()
            lastMessage.text = message?.text
            
            guard let double: Double? = Double(truncating: message!.timestamp!) else {return}
            if let seconds = double {
                let date = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: date)
            }
            
            
        }
        
    }
    
    private func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            print("got it")
            print(id)
            let ref = Firestore.firestore().collection("users").document("\(id)")
            ref.getDocument(source: .default) { (snapshot, error) in
                if let error = error {
                    print(error)
                }
                if let dictionary = snapshot?.data() {
                    print(dictionary)
                    self.pseudoUserLabel.text = dictionary["userName"] as? String
                    
//                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
//                        self.profileUserImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
//                    }
                }
            }
        }
    }
}
