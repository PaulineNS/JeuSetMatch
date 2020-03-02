//
//  UIViewController+NavBar.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 12/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Make navigation bar translucent
    func navigationBarCustom() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
}
