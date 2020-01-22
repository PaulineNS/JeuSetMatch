//
//  UserUseCaseTest.swift
//  JeuSetMatchTests
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import XCTest
@testable import JeuSetMatch


class UserUseCaseTest: XCTestCase {
    
    func test_fetchUser_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for fetch user completion")
        
        sut.fetchUser { (result) in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
            default:
                XCTFail("Expected success, got \(result), result instead")
            }
            
            exp.fulfill()
            
        }
        user.completeFetchUserSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
    }
        
    
    func test_fetchUser_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch users completion")
        sut.fetchUser { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(result), result instead")
            }
            exp.fulfill()
            
        }
        user.completeFetchUserFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_fetchPartnerUser_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for fetch partner user completion")
        
        sut.fetchPartnerUser(chatPartnerId: "") { (result) in
                        switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
            default:
                XCTFail("Expected success, got \(result), result instead")
            }
            
            exp.fulfill()
        }
        
        user.completeFetchUserSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_fetchPartnerUser_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch partner users completion")
        sut.fetchPartnerUser(chatPartnerId: "") { (result) in
                        switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(result), result instead")
            }
            exp.fulfill()
        }
        
        user.completeFetchUserFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_fetchUserInformation_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for fetch user depending uid completion")
        
        sut.fetchUserInformationsDependingUid(userUid: "") { (result) in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
            default:
                XCTFail("Expected success, got \(result), result instead")
            }
            
            exp.fulfill()
        }
        user.completeFetchUserSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
    }
        
    func test_fetchUserInformation_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch user information depending uid completion")
        sut.fetchUserInformationsDependingUid(userUid: "") { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(result), result instead")
            }
            exp.fulfill()
        }
        user.completeFetchUserFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }
        
    class UserSpy: UserUseCaseOutput {

        var userCompletions = [(Result<UserObject, Error>) -> Void]()
        
        func fetchUser(completion: @escaping (Result<UserObject, Error>) -> Void) {
            userCompletions.append(completion)
        }
        
        func fetchPartnerUser(chatPartnerId: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
            userCompletions.append(completion)
        }
        
        func fetchUserInformationsDependingUid(userUid: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
            userCompletions.append(completion)
        }
        
        func completeFetchUserSuccessfully(with user: UserObject, at index: Int = 0) {
            userCompletions[index](.success(user))
        }
        
        func completeFetchUserFail(with error: NSError, at index: Int = 0) {
            userCompletions[index](.failure(error))
        }
    }
    
    func createUser(pseudo: String) -> UserObject {
        return UserObject(pseudo: pseudo, image: nil, sexe: nil, level: nil, city: nil, birthDate: nil, uid: nil)
    }

}
