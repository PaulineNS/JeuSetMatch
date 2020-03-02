//
//  UIViewController+Filters.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 05/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Manage Users Filters

extension UIViewController {
    
    /// Fetch user wiith one filter
    func fetchUsersDependingOneFilter(field1: String, field1value: String, onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void) {
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        userUseCase.fetchUserInformationsDependingOneFilter(field1: field1, field1value: field1value, completion: { (result) in
            switch result {
            case .success(let users):
                onSuccess(users)
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                onNone()
            }
        })
    }
    
    /// Fetch user wiith two filters
    func fetchUsersDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void){
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        userUseCase.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: { (result) in
            switch result {
            case .success(let users):
                onSuccess(users)
                
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                onNone()
            }
        })
    }
    
    /// Fetch user wiith three filters
    func fetchUsersDependingThreeFilters(gender: String, city: String, level: String, onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void) {
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        userUseCase.fetchUserInformationsDependingAllFilters(gender: gender, city: city, level: level, completion: { (result) in
            switch result {
            case .success(let users):
                onSuccess(users)
                
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                onNone()
                
            }
        })
    }
    
    /// Fetch user wiithout filters
    func fetchUsersWithoutFilters(onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void){
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        userUseCase.fetchUserWithoutFilters(completion: { (result) in
            switch result {
            case .success(let users):
                onSuccess(users)
            case .failure(let error):
                print(error.localizedDescription)
            case .none:
                onNone()                
            }
        })
    }
}

