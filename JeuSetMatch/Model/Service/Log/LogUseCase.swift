//
//  LoginUseCase.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

protocol LogUseCaseOutput {
    typealias LoginCompletion = (Result<UserObject, Error>) -> Void
    func logIn(email: String, password: String, completion: @escaping LoginCompletion)
    
    typealias LogOutCompletion = (Bool) -> Void
    func logOut(completion: @escaping LogOutCompletion)
}

class LogUseCase {
    private let client: LogUseCaseOutput
    
    init(client: LogUseCaseOutput) {
        self.client = client
    }
    
    func logIn(with email: String, password: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
        self.client.logIn(email: email, password: password, completion: completion)
    }
    
    func logOut(completion: @escaping (Bool) -> Void){
        self.client.logOut(completion: completion)
    }
}
