//
//  ConversationUseCaseTest.swift
//  JeuSetMatchTests
//
//  Created by Pauline Nomballais on 22/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import XCTest
@testable import JeuSetMatch

class ConversationUseCaseTest: XCTestCase {
    
    // MARK: - Test

    func test_observeMessages_succeeds() {
        let message = ConversationSpy()
        let sut = ConversationUseCase(message: message)
        let expectedMessage = createMessage(message: "message")
        
        let exp = expectation(description: "Wait for observe Message completion")
        sut.observeUserMessages { (result) in
            switch result {
            case .success(let receivedMessage):
                XCTAssertEqual(receivedMessage, expectedMessage)
            default:
                XCTFail("Expected success, got \(String(describing: result)), result instead")
                 }
            exp.fulfill()
            }
        
        message.completeObserveMessageSuccessfully(with: expectedMessage)
        
        wait(for: [exp], timeout: 1.0)
    
        }
    
    
    func test_observeMessages_fails() {
        let message = ConversationSpy()
        let sut = ConversationUseCase(message: message)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for observe Message completion")
        sut.observeUserMessages { (result) in
            switch result {
                case .failure(let receivedError):
                    XCTAssertEqual(receivedError as NSError, expectedError)
                    
                default:
                    XCTFail("Expected failure, got \(String(describing: result)), result instead")
                }
                exp.fulfill()
            }
        
        message.completeObserveMessageFail(with: expectedError)

        wait(for: [exp], timeout: 1.0)
        }
    
    func test_observeChatMessages_succeeds() {
        let message = ConversationSpy()
        let sut = ConversationUseCase(message: message)
        let expectedMessage = createMessage(message: "message")
        
        let exp = expectation(description: "Wait for observe Chat Message completion")
        sut.observeUserChatMessages(toId: "") { (result) in
            switch result {
            case .success(let receivedMessage):
                XCTAssertEqual(receivedMessage, expectedMessage)
            default:
                XCTFail("Expected success, got \(String(describing: result)), result instead")
            }
            exp.fulfill()
        }
        
        message.completeObserveMessageSuccessfully(with: expectedMessage)
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    func test_observeChatMessages_fails() {
        let message = ConversationSpy()
        let sut = ConversationUseCase(message: message)
        let expectedError = NSError(domain: "Fail login", code: 0)
        
        let exp = expectation(description: "Wait for observe Message completion")
        sut.observeUserChatMessages(toId: "") { (result) in
            switch result {
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, expectedError)
                
            default:
                XCTFail("Expected failure, got \(String(describing: result)), result instead")
            }
            exp.fulfill()
        }
        
        message.completeObserveMessageFail(with: expectedError)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_sendMessage_fails() {
        let message = ConversationSpy()
        let sut = ConversationUseCase(message: message)
        let expectedAnswer = false
        
        let exp = expectation(description: "Wait for login completion")
        sut.sendMessage(withProperties: ["":""], toId: "") { isSuccess in
            if !isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        message.sendMessageFail(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_sendMessage_succeeds() {
        let message = ConversationSpy()
        let sut = ConversationUseCase(message: message)
        let expectedAnswer = true
        
        let exp = expectation(description: "Wait for login completion")
        sut.sendMessage(withProperties: ["":""], toId: "") { isSuccess in
            if isSuccess {
                XCTAssertEqual(isSuccess, expectedAnswer)
            }
            exp.fulfill()
        }
        message.sendMessageFail(with: expectedAnswer)
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Spy

    class ConversationSpy: ConversationUseCaseOutput {
        var conversationCompletion = [((Result<MessageObject, Error>)?) -> Void]()
        var sendMessageCompletion = [(Bool) -> Void]()
        
        
        func observeUserMessages(completion: @escaping ((Result<MessageObject, Error>)?) -> Void) {
            conversationCompletion.append(completion)
        }
        
        func observeUserChatMessages(toId: String, completion: @escaping ((Result<MessageObject, Error>)?) -> Void) {
            conversationCompletion.append(completion)
        }
        
        func sendMessage(withProperties: [String : Any], toId: String, completion: @escaping (Bool) -> Void) {
            sendMessageCompletion.append(completion)
        }
        
        func completeObserveMessageSuccessfully(with message: MessageObject, at index: Int = 0) {
            conversationCompletion[index](.success(message))
        }
        
        func completeObserveMessageFail(with error: NSError, at index: Int = 0) {
            conversationCompletion[index](.failure(error))
        }
        
        func sendMessageSuccessfully(with response: Bool, at index: Int = 0) {
            sendMessageCompletion[index](response)
        }
        
        func sendMessageFail(with response: Bool, at index: Int = 0) {
            sendMessageCompletion[index](response)
        }
    }
    
    // MARK: - Create fake message

    func createMessage(message: String) -> MessageObject {
        let dictionnary = [Constants.FStore.fromIdMessage: "", Constants.FStore.toIdMessage: "", Constants.FStore.textMessage: message, Constants.FStore.timestampMessage: nil]
        return MessageObject(dictionary: dictionnary as [String : Any])
    }
}
