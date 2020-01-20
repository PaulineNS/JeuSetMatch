//
//  FirestoreProtocol.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 20/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreProtocol {
    
    func createUser(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping (Result<UserObject, Error>) -> Void)
    
    func checkPseudoDisponibility(field: String, completion: @escaping (Bool) -> Void)
    
    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    
    func fetchUser(completion: @escaping (Result<UserObject, Error>) -> Void)

    func observeUserMessages(completion: @escaping (Result<MessageObject, Error>) -> Void)
    
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping (Result<UserObject, Error>) -> Void)
    
    func observeUserChatMessages(toId: String, completion: @escaping (Result<MessageObject, Error>) -> Void)
    
    func sendMessage(withProperties: [String : Any], toId: String)
    
    func setupNameAndProfileImage(id: String, completion: @escaping (Result<[String:Any], Error>) -> Void)
    
    
    func fetchUserInformationsDependingUid(userUid: String, completion: @escaping (Result<UserObject, Error>) -> Void)
    
    func updateUserInformation(userCity: String, userGender: String, userLevel: String, userName: String)
    
    func logOut()
}

    



 
