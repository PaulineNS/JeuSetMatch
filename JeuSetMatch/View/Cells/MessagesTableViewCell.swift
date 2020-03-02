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
    
    @IBOutlet private weak var profileUserImageView: UIImageView!
    @IBOutlet private weak var pseudoUserLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var lastMessageLabel: UILabel!
    
    // MARK: - Variables
    
    private let firestoreUser = FirestoreUserService()
    lazy private var userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
    var message : MessageObject? {
        didSet {
            setupNameAndProfileImage()
            lastMessageLabel.text = message?.text
            let timestamp = message?.timestamp
            timeLabel.text = convertTimestampToStringDate(timestamp: timestamp as! TimeInterval)
        }
    }
    
    // MARK: - Methods
    
    ///Display name and user profile image
    private func setupNameAndProfileImage() {
        if let id = message?.chatPartnerId() {
            userUseCase.setupNameAndProfileImage(id: id) { (result) in
                switch result {
                case .success(let dictionary) :
                    self.pseudoUserLabel.text = dictionary[Constants.FStore.userPseudoField] as? String
                    if let profileImage = dictionary[Constants.FStore.userPictureField] as? Data {
                        self.profileUserImageView.makeRounded()
                        self.profileUserImageView.image = UIImage(data: profileImage)
                    }
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
    }
}






