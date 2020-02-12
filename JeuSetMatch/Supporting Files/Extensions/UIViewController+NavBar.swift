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
    
    func navigationBarCustom() {
//        let bar: UINavigationBar! = self.navigationController?.navigationBar
//        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        bar.shadowImage = UIImage()
//        bar.alpha = 0.0
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
}
