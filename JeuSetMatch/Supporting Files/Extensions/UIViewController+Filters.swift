//
//  UIViewController+Filters.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 05/02/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func fetchUsersDependingOneFilter(field1: String, field1value: String, onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void) {
        let customLoader = CustomLoader()
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        
        customLoader.showLoaderView()
        userUseCase.fetchUserInformationsDependingOneFilter(field1: field1, field1value: field1value, completion: { (result) in
            customLoader.hideLoaderView()
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
    
    
    func fetchUsersDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void){
        let customLoader = CustomLoader()
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        
        customLoader.showLoaderView()
        userUseCase.fetchUsersInformationsDependingTwoFilters(field1: field1, field1value: field1value, field2: field2, field2Value: field2Value, completion: { (result) in
            customLoader.hideLoaderView()
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
    
    func fetchUsersDependingThreeFilters(gender: String, city: String, level: String, onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void) {
        let customLoader = CustomLoader()
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        
        customLoader.showLoaderView()
        userUseCase.fetchUserInformationsDependingAllFilters(gender: gender, city: city, level: level, completion: { (result) in
            customLoader.hideLoaderView()
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
    
    func fetchUsersWithoutFilters(onSuccess: @escaping (UserObject) -> Void, onNone: @escaping () -> Void){
        let customLoader = CustomLoader()
        let firestoreUser = FirestoreUserService()
        let userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
        
        customLoader.showLoaderView()
        userUseCase.fetchUserWithoutFilters(completion: { (result) in
            customLoader.hideLoaderView()
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

