//
//  FirestoreLoginService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Firebase

class FirestoreLogService: LogUseCaseOutput {
    
    func logOut(completion: @escaping LogOutCompletion) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            completion(false)
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping LoginCompletion) {
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
