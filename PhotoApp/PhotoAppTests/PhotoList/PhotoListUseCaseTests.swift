//
//  PhotoListUseCaseTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import XCTest

final class PhotoListUseCaseTests: XCTestCase {
    
    private var useCase: PhotoListUseCase!
    private let photo = [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "name"))]
    private var encoded: Data!
    
    override func setUpWithError() throws {
        encoded = try! JSONEncoder().encode(photo)
    }
    
    func testSuccess() {
        let expectation = XCTestExpectation(description: "success")
        expectation.expectedFulfillmentCount = 2
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(self.photo, model)
                XCTAssertEqual(self.useCase.page, 2)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(self.photo, model)
                XCTAssertEqual(self.useCase.page, 3)
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
        useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkError(networkError: .invalidStatusCode(with: 300)))
                XCTAssertEqual(self.useCase.page, 1)
                expectation.fulfill()
            }
        }
            
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailureWithDecodeError() {
        let expectation = XCTestExpectation(description: "failureWithDecodeError")
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: Data()))
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
    
    func testIsLoading() {
        let expectation = XCTestExpectation(description: "isLoading")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 2.0) }
        
        let networkManager = MockSuccessNetworkManager(data: encoded, delay: .now() + 0.5)
        useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success:
                networkManager.verify(url: EndPoint(urlInfomation: .photoList(page: 1)).url,
                                      method: .get,
                                      header: [.authorization(key: Secret.APIKey)])
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        useCase.retrievePhotoList { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .duplicatedRequest)
                networkManager.verify(url: EndPoint(urlInfomation: .photoList(page: 1)).url,
                                      method: .get,
                                      header: [.authorization(key: Secret.APIKey)])
                expectation.fulfill()
            }
        }
    }
}


