//
//  UIViewController+Date.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

// MARK: - Manage Dates

extension UIViewController {
    
    ///Convert Date type to Srting Date
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    /// Convert String Type to Date Type
    func convertStringToDate(dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from: dateString) ?? Date()
        return s
    }
    
    /// Convert a date birth to age
    func dateToAge(birthDate: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        guard let intAge = ageComponents.year else {return ""}
        let stringAge = String(intAge)
        return stringAge
    }
    
    /// Check if an age is valid
    func validateAge(birthDate: Date, minimumAge: Date) -> Bool {
        var isValid: Bool = true
        if birthDate > minimumAge {
            isValid = false
        }
        return isValid
    }
}

extension UITableViewCell {
    
    /// Convert a timestamp into data then into String type 
    func convertTimestampToStringDate(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CEST")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

}

