//
//  PhotoListViewModelTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import XCTest

final class PhotoListViewModelTests: XCTestCase {
    func testBind() {
        var range = (0..<1)
        var count = 0
        let maxCount = 3
        let photo = [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))]
        guard let encoded = ModelEncoder().encode(with: photo) else {
            XCTFail()
            return
        }
        
        let requester = SuccessRequester(data: encoded)
        let networkManager = NetworkManager(requester: requester)
        let photoListViewModel = PhotoListViewModel(networkManageable: networkManager)
        
        let expectation = XCTestExpectation(description: "bindingSuccess")
        
        photoListViewModel.bind {
            XCTAssertEqual(range, $0)
            range = (range.upperBound..<range.upperBound + 1)
            count += 1
            if count == maxCount {
                expectation.fulfill()
            }
        }
        
        (0..<maxCount).forEach { _ in
            photoListViewModel.retrievePhotoList(failureHandler: { _ in
                XCTFail()
            })
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailureWithNetworkError() {
        let networkManager = NetworkManager(requester: InvalidDataRequester())
        let photoListViewModel = PhotoListViewModel(networkManageable: networkManager)
        
        let expectation = XCTestExpectation(description: "failureWithNetworkError")
        
        photoListViewModel.bind { _ in
            XCTFail()
        }
        
        photoListViewModel.retrievePhotoList(failureHandler: { error in
            XCTAssertEqual(error, .networkError(networkError: .invalidData))
            expectation.fulfill()
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
        let photoListViewModel = PhotoListViewModel(networkManageable: networkManager)
        
        photoListViewModel.bind { _ in
            XCTFail()
        }
        
        photoListViewModel.retrievePhotoList(failureHandler: { error in
            XCTAssertEqual(error, .decodeError(description: decodeError.localizedDescription))
            expectation.fulfill()
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

