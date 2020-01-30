//
//  UIViewController+Date.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func convertStringToDate(dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from: dateString) ?? Date()
        return s
    }
    
    func dateToAge(birthDate: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        guard let intAge = ageComponents.year else {return ""}
        let stringAge = String(intAge)
        return stringAge
    }
    
    func validateAge(birthDate: Date, minimumAge: Date) -> Bool {
        var isValid: Bool = true
        if birthDate > minimumAge {
            isValid = false
        }
        return isValid
    }
}

