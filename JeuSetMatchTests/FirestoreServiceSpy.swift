//
//  FirestoreServiceSpy.swift
//  JeuSetMatchTests
//
//  Created by Pauline Nomballais on 20/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import Firebase
@testable import JeuSetMatch

class FirestoreServiceSpy: FirestoreProtocol {
    
    var user: ((Result<UserObject, Error>) -> Void)?
    var message: ((Result<MessageObject, Error>) -> Void)?
    
    
    func createUser(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping (Result<UserObject, Error>) -> Void) {
        user = completion
    }
    
    func checkPseudoDisponibility(field: String, completion: @escaping (Bool) -> Void) {
        <#code#>
    }
    
    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        <#code#>
    }
    
    func fetchUser(completion: @escaping (Result<UserObject, Error>) -> Void) {
        user = completion
    }
    
    func observeUserMessages(completion: @escaping (Result<MessageObject, Error>) -> Void) {
        message = completion
    }
    
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
        user = completion
    }
    
    func observeUserChatMessages(toId: String, completion: @escaping (Result<MessageObject, Error>) -> Void) {
        message = completion
    }
    
    func sendMessage(withProperties: [String : Any], toId: String) {
        <#code#>
    }
    
    func setupNameAndProfileImage(id: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
        <#code#>
    }
    
    func fetchUserInformationsDependingUid(userUid: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
        user = completion
    }
    
    func updateUserInformation(userCity: String, userGender: String, userLevel: String, userName: String) {
        <#code#>
    }
    
    func logOut() {
        <#code#>
    }
    
    
}
