//
//  LoginUseCase.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 21/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

protocol LoginProtocol {
    func login(email: String, password: String, completion: @escaping (Result<UserObject, Error>) -> Void)
    func logOut()
}

final class LoginUseCase {
    private let client: LoginProtocol
    
    init(client: LoginProtocol) {
        self.client = client
    }
}
