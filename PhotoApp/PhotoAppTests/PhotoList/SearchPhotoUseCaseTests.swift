//
//  SearchPhotoUseCaseTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/12.
//

@testable import PhotoApp
import XCTest

final class SearchPhotoUseCaseTests: XCTestCase {
    
    private var useCase: SearchPhotoUseCase!
    private let photo = PhotoSearchResult(results: [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "name"))])
    private var encoded: Data!
    
    override func setUpWithError() throws {
        encoded = try! JSONEncoder().encode(photo)
    }
    
    func testSuccess() {
        let expectation = XCTestExpectation(description: "success")
        expectation.expectedFulfillmentCount = 2
        
        
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        useCase = SearchPhotoUseCase(networkManageable: networkManager)
        useCase.retrievePhotoList(with: "query") { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(self.photo, model)
                XCTAssertEqual(self.useCase.page, 2)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        useCase.retrievePhotoList(with: nil) { result in
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
        useCase = SearchPhotoUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList(with: "query") { result in
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
    
    func testQueryAndPreQueryIsNil() {
        let expectation = XCTestExpectation(description: "empty query")
        
        let networkManager = NetworkManager(requester: SuccessRequester())
        useCase = SearchPhotoUseCase(networkManageable: networkManager)
        useCase.retrievePhotoList(with: nil) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkError(networkError: .invalidURL))
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testResetPage() {
        let expectation = XCTestExpectation(description: "page reset")
        expectation.expectedFulfillmentCount = 2
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        useCase = SearchPhotoUseCase(networkManageable: networkManager)
        useCase.retrievePhotoList(with: "query") { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(self.photo, model)
                XCTAssertEqual(self.useCase.page, 2)
                self.useCase.resetPage()
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        useCase.retrievePhotoList(with: "query") { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(self.photo, model)
                XCTAssertEqual(self.useCase.page, 2)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testIsLoading() {
        let expectation = XCTestExpectation(description: "isLoading")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let networkManager = MockSuccessNetworkManager(data: encoded, delay: .now() + 1)
        useCase = SearchPhotoUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList(with: "test") { result in
            switch result {
            case .success:
                networkManager.verify(url: EndPoint.init(urlInfomation: .search(query: "test", page: 1)).url,
                                      method: .get,
                                      header: [.authorization(key: Secret.APIKey)])
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        
        useCase.retrievePhotoList(with: "test") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                networkManager.verify(url: EndPoint.init(urlInfomation: .search(query: "test", page: 1)).url,
                                      method: .get,
                                      header: [.authorization(key: Secret.APIKey)])
                XCTAssertEqual(error, .duplicatedRequest)
                expectation.fulfill()
            }
        }
    }
}
