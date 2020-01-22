//
//  LoginUseCase.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

protocol LoginUseCaseOutput {
    typealias LoginCompletion = (Result<UserObject, Error>) -> Void
    func login(email: String, password: String, completion: @escaping LoginCompletion)
}

class LoginUseCase {
    private let client: LoginUseCaseOutput
    
    init(client: LoginUseCaseOutput) {
        self.client = client
    }
    
    func login(with email: String, password: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
        self.client.login(email: email, password: password, completion: completion)
    }
}
