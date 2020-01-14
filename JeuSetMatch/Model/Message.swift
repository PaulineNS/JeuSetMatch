//
//  Message.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 25/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//
import Firebase
import Foundation

struct Message {
    
    // MARK: - Variables

    let fromId: String?
    let text: String?
    let timestamp: NSNumber?
    let toId: String?
    
    // MARK: - Initialization

    init(dictionary: [String : Any]) {
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
    }
    
    // MARK: - Methods

    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    

}


