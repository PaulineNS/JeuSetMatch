//
//  UserUseCase.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

protocol UserUseCaseOutput {
    
    typealias UserCompletion = ((Result<UserObject, Error>)?) -> Void
    
    func fetchUserWithoutFilters(completion: @escaping UserCompletion)
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingOneFilter(field1: String, field1value: String, completion: @escaping UserCompletion)
    func fetchUsersInformationsDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingAllFilters(gender: String, city: String, level: String, completion: @escaping UserCompletion)


}

class UserUseCase {
    
    private let user: UserUseCaseOutput
    
    init(user: UserUseCaseOutput) {
        self.user = user
    }
    
    func fetchUserWithoutFilters(completion: @escaping ((Result<UserObject, Error>)?) -> Void) {
        self.user.fetchUserWithoutFilters(completion: completion)
    }
    
    func fetchPartnerUser(chatPartnerId: String, completion: @escaping ((Result<UserObject, Error>)?) -> Void){
        self.user.fetchPartnerUser(chatPartnerId: chatPartnerId, completion: completion)
    }
    
    func fetchUserInformationsDependingOneFilter(field1: String, field1value: String, completion: @escaping ((Result<UserObject, Error>)?) -> (Void)){
        self.user.fetchUserInformationsDependingOneFilter(field1: field1, field1value: field1value, completion: completion)
    }
    
    func fetchUsersInformationsDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, completion: @escaping ((Result<UserObject, Error>)?) -> Void){
        self.user.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: completion)
    }
    
    func fetchUserInformationsDependingAllFilters(gender: String, city: String, level: String, completion: @escaping ((Result<UserObject, Error>)?) -> Void) {
        self.user.fetchUserInformationsDependingAllFilters(gender: gender, city: city, level: level, completion: completion)
    }
}



