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
    
    // MARK: - Tests

    func test_fetchPartnerWithoutFilter_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for fetch user depending uid completion")
        
        sut.fetchUserWithoutFilters { (result) in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
            default:
                XCTFail("Expected success, got \(String(describing: result)), result instead")
            }
            
            exp.fulfill()
        }
        user.completeFetchUserSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
        }
    
    func test_fetchPartnerWithoutFilter_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch users completion")
        sut.fetchUserWithoutFilters { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(String(describing: result)), result instead")
            }
            exp.fulfill()
            
        }
        user.completeFetchUserFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
        }
    
    func test_fetchPartnerDependingOneFilter_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for fetch user depending uid completion")
        
        sut.fetchUserInformationsDependingOneFilter(field1: "", field1value: "") { (result) in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
            default:
                XCTFail("Expected success, got \(String(describing: result)), result instead")
            }
            
            exp.fulfill()
        }
        user.completeFetchUserSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
        }
    
    
    func test_fetchPartnerDependingOneFilter_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch users completion")
        sut.fetchUserInformationsDependingOneFilter(field1: "", field1value: "") { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(String(describing: result)), result instead")
            }
            exp.fulfill()
            
        }
        user.completeFetchUserFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
        }
    
    
    func test_fetchPartnerDependingTwoFilters_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for fetch user depending uid completion")
        
        sut.fetchUsersInformationsDependingTwoFilters(field1: "", field1value: "", field2: "", field2Value: "") { (result) in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
            default:
                XCTFail("Expected success, got \(String(describing: result)), result instead")
            }
            
            exp.fulfill()
        }
        user.completeFetchUserSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
        }
    
    
    func test_fetchPartnerDependingTwoFilters_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch users completion")
        sut.fetchUsersInformationsDependingTwoFilters(field1: "", field1value: "", field2: "", field2Value: "") { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(String(describing: result)), result instead")
            }
            exp.fulfill()
            
        }
        user.completeFetchUserFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
        }
    
    func test_fetchPartnerDependingThreeFilters_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for fetch user depending uid completion")
        
        sut.fetchUserInformationsDependingAllFilters(gender: "", city: "", level: "") { (result) in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
            default:
                XCTFail("Expected success, got \(String(describing: result)), result instead")
            }
            
            exp.fulfill()
        }
        user.completeFetchUserSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
        }
    
    func test_fetchPartnerDependingThreeFilters_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch users completion")
        sut.fetchUserInformationsDependingAllFilters(gender: "", city: "", level: "") { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(String(describing: result)), result instead")
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
                XCTFail("Expected success, got \(String(describing: result)), result instead")
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
                XCTFail("Expected failure, got \(String(describing: result)), result instead")
            }
            exp.fulfill()
        }
        
        user.completeFetchUserFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_setUp_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedInformations = createInformationDictionnary(informationField: "test", valueField: "test")
        
        let exp = expectation(description: "Wait for fetch partner user completion")
        
        sut.setupNameAndProfileImage(id: "") { (result) in
            switch result {
            case .success(let receivedInformations):
                XCTAssertNotNil(receivedInformations)
            default:
                XCTFail("Expected success, got \(String(describing: result)), result instead")
            }
            
            exp.fulfill()
        }
        
        user.completeSetUpSuccessfully(with: expectedInformations)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_setUp_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for fetch partner users completion")
        sut.setupNameAndProfileImage(id: "") { (result) in
                        switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(String(describing: result)), result instead")
            }
            exp.fulfill()
        }
        
        user.completeSetUpFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_updateUser_fails() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedAnswer = false
        
        let exp = expectation(description: "Wait for login completion")
        sut.updateUserInformation(userAge: "", userCity: "", userGender: "", userLevel: "", userImage: Data()) { isSuccess in
            if !isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        user.updateUserFail(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_updateUser_succeeds() {
        let user = UserSpy()
        let sut = UserUseCase(user: user)
        let expectedAnswer = true
        
        let exp = expectation(description: "Wait for login completion")
        sut.updateUserInformation(userAge: "", userCity: "", userGender: "", userLevel: "", userImage: Data()) { isSuccess in
            if isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        user.updateUserSuccessfully(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
        
    // MARK: - Spy

    class UserSpy: UserUseCaseOutput {
        
        var userCompletions = [((Result<UserObject, Error>)?) -> Void]()
        var updateUserCompletion = [(Bool) -> Void]()
        var setUpCompletion = [(Result<[String:Any], Error>) -> Void]()
        
        func fetchUserWithoutFilters(completion: @escaping ((Result<UserObject, Error>)?) -> Void) {
            userCompletions.append(completion)
        }
        
        func fetchPartnerUser(chatPartnerId: String, completion: @escaping ((Result<UserObject, Error>)?) -> Void) {
            userCompletions.append(completion)
        }
        
        func fetchUserInformationsDependingOneFilter(field1: String, field1value: String, completion: @escaping ((Result<UserObject, Error>)?) -> Void) {
            userCompletions.append(completion)
        }
        
        func fetchUsersInformationsDependingTwoFilters(field1: String, field1value: String, field2: String, field2Value: String, completion: @escaping ((Result<UserObject, Error>)?) -> Void) {
            userCompletions.append(completion)
        }
        
        func fetchUserInformationsDependingAllFilters(gender: String, city: String, level: String, completion: @escaping ((Result<UserObject, Error>)?) -> Void) {
            userCompletions.append(completion)
        }
        
        func setupNameAndProfileImage(id: String, completion: @escaping (Result<[String:Any], Error>) -> Void) {
            setUpCompletion.append(completion)
        }
        
        func updateUserInformation(userAge: String, userCity: String, userGender: String, userLevel: String, userImage: Data, completion: @escaping (Bool) -> Void) {
            updateUserCompletion.append(completion)
        }
        
        func completeFetchUserSuccessfully(with user: UserObject, at index: Int = 0) {
            userCompletions[index](.success(user))
        }
        
        func completeFetchUserFail(with error: NSError, at index: Int = 0) {
            userCompletions[index](.failure(error))
        }
        
        func completeSetUpSuccessfully(with informations: [String:Any], at index: Int = 0) {
            setUpCompletion[index](.success(informations))
        }
        
        func completeSetUpFail(with error: NSError, at index: Int = 0) {
            setUpCompletion[index](.failure(error))
        }
        
        func updateUserSuccessfully(with response: Bool, at index: Int = 0) {
            updateUserCompletion[index](response)
        }
        
        func updateUserFail(with response: Bool, at index: Int = 0) {
            updateUserCompletion[index](response)
        }
    }
    
    // MARK: - Create Fake User

    func createUser(pseudo: String) -> UserObject {
        return UserObject(pseudo: pseudo, image: nil, sexe: nil, level: nil, city: nil, birthDate: nil, uid: nil)
    }
    
    func createInformationDictionnary(informationField: String, valueField: String) -> [String:Any] {
        return [informationField:valueField]
    }
}
