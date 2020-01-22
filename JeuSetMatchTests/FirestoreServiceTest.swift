//
//  FirestoreServiceTest.swift
//  JeuSetMatchTests
//
//  Created by Pauline Nomballais on 18/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import XCTest
@testable import JeuSetMatch

class LoginUseCaseTest: XCTestCase {
    
    func test_login_succeeds() {
        let client = LoginSpy()
        let sut = LoginUseCase(client: client)
        let expectedUser = createUser(pseudo: "Test")
        
        let exp = expectation(description: "Wait for login completion")
        sut.login(with: "User email", password: "User Password") { result in
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
        let sut = LoginUseCase(client: client)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for login completion")
        sut.login(with: "User email", password: "User Password") { result in
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
    
    class LoginSpy: LoginUseCaseOutput {
        var loginCompletions = [(Result<UserObject, Error>) -> Void]()
        
        func login(email: String, password: String, completion: @escaping (Result<UserObject, Error>) -> Void) {
            loginCompletions.append(completion)
        }
        
        func completeLoginSuccessfully(with user: UserObject, at index: Int = 0) {
            loginCompletions[index](.success(user))
        }
        
        func completeLoginFail(with error: NSError, at index: Int = 0) {
            loginCompletions[index](.failure(error))
        }
    }
    
    func createUser(pseudo: String) -> UserObject {
        return UserObject(pseudo: pseudo, image: nil, sexe: nil, level: nil, city: nil, birthDate: nil, uid: nil)
    }
}





        

