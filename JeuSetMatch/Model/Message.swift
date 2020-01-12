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
    
    let fromId: String?
    let text: String?
    let timestamp: NSNumber?
    let toId: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    init(dictionary: [String : Any]) {
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
    }
}


