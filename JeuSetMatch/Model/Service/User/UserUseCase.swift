//
//  UserUseCase.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

protocol UserUseCaseOutput {
    
    typealias UserCompletion = (Result<UserObject, Error>) -> Void
    
    func fetchUser(completion: @escaping UserCompletion)
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingUid(userUid: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingFilters(gender: String, city: String, level: String, completion: @escaping UserCompletion)

}

class UserUseCase {
    
    private let user: UserUseCaseOutput
    
    init(user: UserUseCaseOutput) {
        self.user = user
    }
    
    func fetchUser(completion: @escaping (Result<UserObject, Error>) -> Void) {
        self.user.fetchUser(completion: completion)
    }
    
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchPartnerUser(chatPartnerId: chatPartnerId, completion: completion)
    }
    
    func fetchUserInformationsDependingUid(userUid: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
        self.user.fetchUserInformationsDependingUid(userUid: userUid, completion: completion)
    }
    
    func fetchUserInformationsDependingFilters(gender: String, city: String, level: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
        self.user.fetchUserInformationsDependingFilters(gender: gender, city: city, level: level, completion: completion)
    }
}



