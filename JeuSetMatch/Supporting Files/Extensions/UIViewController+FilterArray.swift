//
//  UIViewController+FilterArray.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 19/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func find(value searchValue: String, in array: [String]) -> Int? {
        for (index, value) in array.enumerated(){
            if value == searchValue {
                return index
            }
        }
        return nil
    }
}

extension UIViewController {
    
    func find(value searchValue: String, in array: [String]) -> Int? {
        for (index, value) in array.enumerated(){
            if value == searchValue {
                return index
            }
        }
        return nil
    }
    
}
