//
//  MessageTableViewCell.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 26/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rightAvatarImageView: UIImageView!
    @IBOutlet weak var leftAvatarImageView: UIImageView!
    
    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }
}
