//
//  Message.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 25/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//
import Foundation

struct MessageObject: Equatable {
    
    // MARK: - Equatable

    static func == (lhs: MessageObject, rhs: MessageObject) -> Bool {
        return true
    }
    
//    let firestoreService = FirestoreService()
    private let firestoreUser = FirestoreUserService()
    
    // MARK: - Variables

    let fromId: String?
    let text: String?
    let timestamp: NSNumber?
    let toId: String?
    
    // MARK: - Initialization

    init(dictionary: [String : Any]) {
        fromId = dictionary[Constants.FStore.fromIdMessage] as? String
        toId = dictionary[Constants.FStore.toIdMessage] as? String
        text = dictionary[Constants.FStore.textMessage] as? String
        timestamp = dictionary[Constants.FStore.timestampMessage] as? NSNumber
    }
    
    // MARK: - Methods

    func chatPartnerId() -> String? {
        return fromId == firestoreUser.currentUserUid ? toId : fromId
    }
}


