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
    
    func fetchUserInformationsDependingLevel(level: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingCity(city: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingSexe(sexe: String, completion: @escaping UserCompletion)

    func fetchUserInformationsDependingCityAndLevel(level: String, city: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingCityAndSexe(sexe: String, city: String, completion: @escaping UserCompletion)
    func fetchUserInformationsDependingSexeAndLevel(sexe: String, level: String, completion: @escaping UserCompletion)
    
    func fetchUserInformationsOneFilter(field1: String, field1value: String, completion: @escaping UserCompletion)
    
    func fetchUsersInformationsDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, completion: @escaping UserCompletion)

}

class UserUseCase {
    
    private let user: UserUseCaseOutput
    
    init(user: UserUseCaseOutput) {
        self.user = user
    }
    
    
    func fetchUserInformationsOneFilter(field1: String, field1value: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUserInformationsOneFilter(field1: field1, field1value: field1value, completion: completion)
    }
    
    func fetchUsersInformationsDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: completion)
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
    
    func fetchUserInformationsDependingLevel(level: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUserInformationsDependingLevel(level: level, completion: completion)
    }
    
    func fetchUserInformationsDependingCity(city: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUserInformationsDependingCity(city: city, completion: completion)
    }
    
    func fetchUserInformationsDependingSexe(sexe: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUserInformationsDependingSexe(sexe: sexe, completion: completion)
    }

    func fetchUserInformationsDependingCityAndLevel(level: String, city: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUserInformationsDependingCityAndLevel(level: level, city: city, completion: completion)
    }
    
    func fetchUserInformationsDependingCityAndSexe(sexe: String, city: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUserInformationsDependingCityAndSexe(sexe: sexe, city: city, completion: completion)
    }
    
    func fetchUserInformationsDependingSexeAndLevel(sexe: String, level: String, completion: @escaping (Result<UserObject, Error>) -> Void){
        self.user.fetchUserInformationsDependingSexeAndLevel(sexe: sexe, level: level, completion: completion)
    }
}



