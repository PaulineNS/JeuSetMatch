//
//  RegisterUseCaseTest.swift
//  JeuSetMatchTests
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import XCTest
@testable import JeuSetMatch

class RegisterUseCaseTest: XCTestCase {
    
    // MARK: - Tests
    
    func test_register_succeeds() {
        let client = RegisterSpy()
        let sut = RegisterUseCase(client: client)
        let expectedUser = createUser(pseudo: "pseudo")
        
        let exp = expectation(description: "Wait for register completion")
        sut.register(email: "User Email", password: "User Password", userAge: "User Age", userGender: "user Gender", userLevel: "user Level", userCity: "User City", userName: "User Name", userImage: "User Image") { (result) in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
                
            default:
                XCTFail("Expected success, got \(result), result instead")
            }
            exp.fulfill()
        }
        
        client.completeRegisterSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_register_fails() {
        let client = RegisterSpy()
        let sut = RegisterUseCase(client: client)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for login completion")
        sut.register(email: "User Email", password: "User Password", userAge: "User Age", userGender: "user Gender", userLevel: "user Level", userCity: "User City", userName: "User Name", userImage: "User Image") { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(result), result instead")
            }
            exp.fulfill()
        }
        
        client.completeRegisterFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_checkPseudo_fails() {
        let client = RegisterSpy()
        let sut = RegisterUseCase(client: client)
        let expectedAnswer = false
        
        let exp = expectation(description: "Wait for login completion")
        sut.checkPseudoDisponibility(field: "") { isSuccess in
            if !isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        client.Succeedeed(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_checkPseudo_succeeds() {
        let client = RegisterSpy()
        let sut = RegisterUseCase(client: client)
        let expectedAnswer = true
        
        let exp = expectation(description: "Wait for login completion")
        sut.checkPseudoDisponibility(field: "") { isSuccess in
            if isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        client.Succeedeed(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_deleteAccount_fails() {
        let client = RegisterSpy()
        let sut = RegisterUseCase(client: client)
        let expectedAnswer = false
        
        let exp = expectation(description: "Wait for login completion")
        sut.deleteAccount { isSuccess in
            if !isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        client.Succeedeed(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_deleteAccount_succeeds() {
        let client = RegisterSpy()
        let sut = RegisterUseCase(client: client)
        let expectedAnswer = true
        
        let exp = expectation(description: "Wait for login completion")
        sut.deleteAccount { isSuccess in
            if isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        client.Succeedeed(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Spy

    class RegisterSpy: RegisterUseCaseOutput {
        var registerCompletions = [(Result<UserObject, Error>) -> Void]()
        var isSuccededCompletion = [(Bool) -> Void]()
        
        func register(email: String, password: String, userAge: Any, userGender: Any, userLevel: Any, userCity: Any, userName: Any, userImage: Any, completion: @escaping (Result<UserObject, Error>) -> Void) {
            registerCompletions.append(completion)
        }
        
        func completeRegisterSuccessfully(with user: UserObject, at index: Int = 0) {
            registerCompletions[index](.success(user))
        }
        
        func completeRegisterFail(with error: NSError, at index: Int = 0) {
            registerCompletions[index](.failure(error))
        }
        
        // Pseudo Disponibility
        func checkPseudoDisponibility(field: String, completion: @escaping (Bool) -> Void) {
            isSuccededCompletion.append(completion)
        }
        
        func deleteAccount(completion: @escaping (Bool) -> Void) {
            isSuccededCompletion.append(completion)
        }
        
        func Succeedeed(with response: Bool, at index: Int = 0) {
            isSuccededCompletion[index](response)
        }
        
        func SuccedeedFail(with response: Bool, at index: Int = 0) {
            isSuccededCompletion[index](response)
        }
        

    }
    
    // MARK: - Create Fake user

    func createUser(pseudo: String) -> UserObject {
        return UserObject(pseudo: pseudo, image: nil, sexe: nil, level: nil, city: nil, birthDate: nil, uid: nil)
    }
    
    func createPseudo(pseudo: String) -> String {
        return pseudo
    }
}



