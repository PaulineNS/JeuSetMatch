//
//  UIImageView.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import UIKit
import ImageIO

// MARK: - Manage Gif UIImageView

extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}

