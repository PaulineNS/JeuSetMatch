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
    
    func makeRounded() {
        
//        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
//        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.bounds.width / 2
//            self.frame.size.width / 2
//            self.frame.height / 2
//        self.clipsToBounds = true
        self.contentMode = .scaleToFill


    }
    
}

