//
//  ConversationUseCase.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

protocol ConversationUseCaseOutput {
    typealias ConversationCompletion = ((Result<MessageObject, Error>)?) -> Void
    
    func observeUserMessages(completion: @escaping ConversationCompletion)
    func observeUserChatMessages(toId: String, completion: @escaping ConversationCompletion)
}

class ConversationUseCase {
    
    private let message: ConversationUseCaseOutput
    
    init(message: ConversationUseCaseOutput) {
        self.message = message
    }
    
    func observeUserMessages(completion: @escaping ((Result<MessageObject, Error>)?) -> Void){
        self.message.observeUserMessages(completion: completion)
    }
    
    func observeUserChatMessages(toId: String, completion: @escaping ((Result<MessageObject, Error>)?) -> Void){
        self.message.observeUserChatMessages(toId: toId, completion: completion)
    }
}
