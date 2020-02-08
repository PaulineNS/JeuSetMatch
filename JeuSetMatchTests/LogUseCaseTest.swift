//
//  FirestoreServiceTest.swift
//  JeuSetMatchTests
//
//  Created by Pauline Nomballais on 18/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import XCTest
@testable import JeuSetMatch

class LogUseCaseTest: XCTestCase {
    
    // MARK: - Tests

    func test_login_succeeds() {
        let client = LoginSpy()
        let sut = LogUseCase(client: client)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for login completion")
        sut.logIn(with: "User email", password: "User Password") { result in
            switch result {
            case .success(let receivedUser):
                XCTAssertEqual(receivedUser, expectedUser)
                
            default:
                XCTFail("Expected success, got \(result), result instead")
            }
            
            exp.fulfill()
        }
        
        client.completeLoginSuccessfully(with: expectedUser)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_login_fails() {
        let client = LoginSpy()
        let sut = LogUseCase(client: client)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for login completion")
        sut.logIn(with: "User email", password: "User Password") { result in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(result), result instead")
            }
            
            exp.fulfill()
        }
        
        client.completeLoginFail(with: expectedError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_logOut_fails() {
        let client = LoginSpy()
        let sut = LogUseCase(client: client)
        let expectedAnswer = false
        
        let exp = expectation(description: "Wait for login completion")
        sut.logOut { isSuccess in
            if !isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        client.completeLogOutFail(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_logOut_succeeds() {
        let client = LoginSpy()
        let sut = LogUseCase(client: client)
        let expectedAnswer = true
        
        let exp = expectation(description: "Wait for login completion")
        sut.logOut { isSuccess in
            if isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        client.completeLogOutSuccessfully(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Spy

    class LoginSpy: LogUseCaseOutput {
        
        var loginCompletions = [(Result<UserObject, Error>) -> Void]()
        var logOutCompletions = [(Bool) -> Void]()
        
        func logIn(email: String, password: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
            loginCompletions.append(completion)
        }
        
        func logOut(completion: @escaping (Bool) -> Void) {
            logOutCompletions.append(completion)
        }
        
        func completeLoginSuccessfully(with user: UserObject, at index: Int = 0) {
            loginCompletions[index](.success(user))
        }
        
        func completeLoginFail(with error: NSError, at index: Int = 0) {
            loginCompletions[index](.failure(error))
        }
        
        func completeLogOutSuccessfully(with response: Bool, at index: Int = 0) {
            logOutCompletions[index](response)
        }
        
        func completeLogOutFail(with response: Bool, at index: Int = 0) {
            logOutCompletions[index](response)
        }
    }
    
    // MARK: - Create fake user

    func createUser(pseudo: String) -> UserObject {
        return UserObject(pseudo: pseudo, image: nil, sexe: nil, level: nil, city: nil, birthDate: nil, uid: nil)
    }
}






        

