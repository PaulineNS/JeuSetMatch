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


//    func fetchUserInformationsDependingUid(userUid: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
////        self.userInformations = []
//        db.collection("users").whereField("userUid", isEqualTo: userUid).addSnapshotListener { (querySnapshot, error) in
//            if let error = error {
//                print("There was an issue retrieving data from Firestore\(error)")
//                completion(.failure(FireStoreError.noData))
//                return
//            } else {
//                guard let snapshotDocuments = querySnapshot?.documents else {return}
//                for doc in snapshotDocuments {
//                    let data = doc.data()
//                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String, let userUid = data["userUid"] as? String else {return}
//                    let user = UserObject(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: userUid)
//                    completion(.success(user))
//                }
//            }
//        }
//    }


