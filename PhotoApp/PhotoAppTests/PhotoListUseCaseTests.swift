//
//  PhotoListUseCaseTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import XCTest

final class PhotoListUseCaseTests: XCTestCase {
    func testSuccess() {
        let expectation = XCTestExpectation(description: "success")
        
        let photo = [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "name"))]
        guard let encoded = ModelEncoder().encode(with: photo) else {
            XCTFail()
            return
        }
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        let useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList(
            failureHandler: { _ in
                XCTFail()
            },
            successHandler: {
                let retrievedPhoto = $0
                XCTAssertEqual(photo, retrievedPhoto)
                XCTAssertEqual(useCase.page, 2)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 5.0)
        
        let expecation2 = XCTestExpectation(description: "success2")
        useCase.retrievePhotoList(
            failureHandler: { _ in
                XCTFail()
            },
            successHandler: {
                let retrievedPhoto = $0
                XCTAssertEqual(photo, retrievedPhoto)
                XCTAssertEqual(useCase.page, 3)
                expecation2.fulfill()
            })
        
        wait(for: [expecation2], timeout: 5.0)
    }
    
    func testFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failureWithNetworkError")
        
        let networkManager = NetworkManager(requester: InvalidStatusCodeReqeuster(with: 300))
        let useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList(
            failureHandler: { error in
                XCTAssertEqual(error, .networkError(networkError: .invalidStatusCode(with: 300)))
                XCTAssertEqual(useCase.page, 1)
                expectation.fulfill()
            },
            successHandler: { _ in
                XCTFail()
            })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailureWithDecodeError() {
        struct Fake: Encodable {
            let name: String
        }
        
        let expectation = XCTestExpectation(description: "failureWithDecodeError")
        let fake = Fake(name: "fake")
        
        guard let encoded = ModelEncoder().encode(with: fake) else {
            XCTFail()
            return
        }
        
        guard let decodeError = getDecodeError() else {
            XCTFail()
            return
        }
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        let useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList(
            failureHandler: { error in
                XCTAssertEqual(error, .decodeError(description: decodeError.localizedDescription))
                XCTAssertEqual(useCase.page, 1)
                expectation.fulfill()
                
            },
            successHandler: { _ in
                XCTFail()
            })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    private func getDecodeError() -> Error? {
        let data = Data()
        do {
            _ = try JSONDecoder().decode(Photo.self, from: data)
            return nil
        } catch {
            return error
        }
    }
}


