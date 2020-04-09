//
//  RegisterUserCase.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

protocol RegisterUseCaseOutput {
    typealias RegisterCompletion = (Result<UserObject, Error>) -> Void
    typealias CheckPseudoDisponibilityCompletion = (Bool) -> Void
    typealias DeleteAccountCompletion = (Bool) -> Void
    
    func register(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping RegisterCompletion)
    
    func checkPseudoDisponibility(field: String, completion: @escaping CheckPseudoDisponibilityCompletion)
    
    func deleteAccount(completion: @escaping DeleteAccountCompletion)

}

class RegisterUseCase {
    private let client: RegisterUseCaseOutput
    
    init(client: RegisterUseCaseOutput) {
        self.client = client
    }
    
    func register(email: String,
                  password: String,
                  userAge: Any,
                  userGender: Any,
                  userLevel: Any,
                  userCity: Any,
                  userName: Any,
                  userImage: Any,
                  completion: @escaping (Result<UserObject, Error>) -> Void) {
        self.client.register(email: email, password: password, userAge: userAge, userGender: userGender, userLevel: userLevel, userCity: userCity, userName: userName, userImage: userImage, completion: completion)
    }
    
    func checkPseudoDisponibility(field: String, completion: @escaping (Bool) -> Void) {
        self.client.checkPseudoDisponibility(field: field, completion: completion)
    }
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        self.client.deleteAccount(completion: completion)
    }
}
