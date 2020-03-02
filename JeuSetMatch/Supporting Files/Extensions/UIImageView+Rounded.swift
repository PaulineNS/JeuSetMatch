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
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2
        self.contentMode = .scaleAspectFill
    }
}

