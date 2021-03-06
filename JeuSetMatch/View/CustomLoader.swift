//
//  CustomLoader.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 25/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import UIKit
import ImageIO


final class CustomLoader: UIView {
    
    // MARK: - Variables

    var setAlpha: CGFloat = 0.5
    var gifName: String = "giphy"
    var viewColor: UIColor = UIColor.gray
    
    ///manage transparent view under the loader
    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        transparentView.isUserInteractionEnabled = false
        return transparentView
    }()
    
    ///Manage the loader gif
    lazy var gifImage: UIImageView = {
        var gifImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        gifImage.contentMode = .scaleAspectFit
        gifImage.center = transparentView.center
        gifImage.isUserInteractionEnabled = false
        gifImage.loadGif(name: gifName)
        return gifImage
    }()
    
    // MARK: - Methods

    ///Show the loader
    func showLoaderView() {
        self.addSubview(self.transparentView)
        self.transparentView.addSubview(self.gifImage)
        self.transparentView.bringSubviewToFront(self.gifImage)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
    }
    
    func hideLoaderView() {
        self.transparentView.removeFromSuperview()
    }
}
