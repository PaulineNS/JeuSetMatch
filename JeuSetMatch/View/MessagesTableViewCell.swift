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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }

    var message : Message? {
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
    
    private func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            print("got it")
            print(id)
            
            db.collection("users").document("\(id)").getDocument(source: .default) { (snapshot, error) in
                if let error = error {
                    print(error)
                }
                if let dictionary = snapshot?.data() {
                    print(dictionary)

                    self.pseudoUserLabel.text = dictionary["userName"] as? String
                    
                    if let profileImage = dictionary["userImage"] as? Data {
                        self.profileUserImageView.image = UIImage(data: profileImage)
                    }
                }
            }
        }
    }
}
