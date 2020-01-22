//
//  FirestoreLoginService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Firebase

class FirestoreLoginService: LoginUseCaseOutput {
    func login(email: String, password: String, completion: @escaping LoginCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let authResult = authResult else {
                completion(.failure(error!))
                return
            }
            
            let user = UserObject(pseudo: authResult.user.email, image: nil, sexe: nil, level: nil, city: nil, birthDate: nil, uid: nil)
            
            completion(.success(user))
        }
    }
}
