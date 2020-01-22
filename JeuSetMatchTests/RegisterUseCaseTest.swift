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
    
//    func test_checkPassword_success() {
//        let client = RegisterSpy()
//        let sut = RegisterUseCase(client: client)
//        let expectedPseudo = createPseudo(pseudo: "pseudo")
//        
//        let exp = expectation(description: "Wait for checking password completion")
//        sut.checkPseudoDisponibility(field: "Pseudo") { (result) in
//            switch result {
//            case true:
//                XCTAssertEqual(receivedUser, expectedPseudo)
//            default:
//                XCTFail("Expected success, got \(result), result instead")
//            }
//        }
//    }
    
    class RegisterSpy: RegisterUseCaseOutput {
        
        // completions
        var registerCompletions = [(Result<UserObject, Error>) -> Void]()
        var checkPseudoCompletion = [(Bool) -> Void]()
        
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
            checkPseudoCompletion.append(completion)
        }
    }
    
    func createUser(pseudo: String) -> UserObject {
        return UserObject(pseudo: pseudo, image: nil, sexe: nil, level: nil, city: nil, birthDate: nil, uid: nil)
    }
    
    func createPseudo(pseudo: String) -> String {
        return pseudo
    }
}



