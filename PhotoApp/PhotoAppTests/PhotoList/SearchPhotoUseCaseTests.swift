//
//  SearchPhotoUseCaseTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/12.
//

@testable import PhotoApp
import XCTest

final class SearchPhotoUseCaseTests: XCTestCase {
    func testSuccess() {
        let expectation = XCTestExpectation(description: "success")
        expectation.expectedFulfillmentCount = 2
        let photo = PhotoSearchResult(results: [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "name"))])
        
        guard let encoded = ModelEncoder().encode(with: photo) else {
            XCTFail()
            return
        }
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        let useCase = SearchPhotoUseCase(networkManageable: networkManager)
        useCase.retrievePhotoList(
            with: "query",
            failureHandler: { _ in
                XCTFail()
            }, successHandler: {
                let result = $0
                XCTAssertEqual(photo, result)
                XCTAssertEqual(useCase.page, 2)
                expectation.fulfill()
            })
        
        useCase.retrievePhotoList(
            with: nil,
            failureHandler: { _ in
                XCTFail()
            },
            successHandler: {
                let retrievedPhoto = $0
                XCTAssertEqual(photo, retrievedPhoto)
                XCTAssertEqual(useCase.page, 3)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failureWithNetworkError")
        
        let networkManager = NetworkManager(requester: InvalidStatusCodeReqeuster(with: 300))
        let useCase = SearchPhotoUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList(
            with: "query",
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
    
    func testQueryAndPreQueryIsNil() {
        let expectation = XCTestExpectation(description: "empty query")
        
        let networkManager = NetworkManager(requester: SuccessRequester())
        let useCase = SearchPhotoUseCase(networkManageable: networkManager)
        useCase.retrievePhotoList(
            with: nil,
            failureHandler: {
                XCTAssertEqual($0, .networkError(networkError: .invalidURL))
                expectation.fulfill()
            }, successHandler: { _ in
                XCTFail()
            })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testResetPage() {
        let expectation = XCTestExpectation(description: "page reset")
        expectation.expectedFulfillmentCount = 2
        let photo = PhotoSearchResult(results: [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "name"))])
        
        guard let encoded = ModelEncoder().encode(with: photo) else {
            XCTFail()
            return
        }
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        let useCase = SearchPhotoUseCase(networkManageable: networkManager)
        useCase.retrievePhotoList(
            with: "query",
            failureHandler: { _ in
                XCTFail()
            }, successHandler: {
                let result = $0
                XCTAssertEqual(photo, result)
                XCTAssertEqual(useCase.page, 2)
                useCase.resetPage()
                expectation.fulfill()
            })
        
        useCase.retrievePhotoList(
            with: "query",
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
    }
}
