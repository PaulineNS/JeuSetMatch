//
//  UIImageView+Rounded.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 10/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Make an UIImageview round
    func makeRounded() {
<<<<<<< HEAD
=======
        
//        self.layer.borderWidth = 1
>>>>>>> parent of a1fd7a2... Managed fetch tasks according lists
        self.layer.masksToBounds = true
//        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.bounds.width / 2
//            self.frame.size.width / 2
//            self.frame.height / 2
//        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

