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
        expectation.expectedFulfillmentCount = 2
        
        let photo = [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "name"))]
        let encoded = try! JSONEncoder().encode(photo)
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        let useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(photo, model)
                XCTAssertEqual(useCase.page, 2)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(photo, model)
                XCTAssertEqual(useCase.page, 3)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailureWithNetworkError() {
        let expectation = XCTestExpectation(description: "failureWithNetworkError")
        
        let networkManager = NetworkManager(requester: InvalidStatusCodeReqeuster(with: 300))
        let useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkError(networkError: .invalidStatusCode(with: 300)))
                XCTAssertEqual(useCase.page, 1)
                expectation.fulfill()
            }
        }
            
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailureWithDecodeError() {
        struct Fake: Encodable {
            let name: String
        }
        
        let expectation = XCTestExpectation(description: "failureWithDecodeError")
        let fake = Fake(name: "fake")
        
        let encoded = try! JSONEncoder().encode(fake)
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        let useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .decodeError)
                XCTAssertEqual(useCase.page, 1)
                expectation.fulfill()
            }
        }
            
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


