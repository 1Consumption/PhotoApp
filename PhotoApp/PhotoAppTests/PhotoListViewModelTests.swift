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
}

