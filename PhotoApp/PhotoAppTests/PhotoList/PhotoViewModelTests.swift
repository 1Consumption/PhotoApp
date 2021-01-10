//
//  PhotoViewModelTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class PhotoViewModelTests: XCTestCase {
    func testBind() {
        let expectation = XCTestExpectation(description: "bindSuccess")
        let photo = Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))
        let viewModel = PhotoViewModel(photo: photo, imageRetrievable: SuccessRetriever())
        
        viewModel.bind {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }
        viewModel.retrieveImage()
        
        wait(for: [expectation], timeout: 5.0)
    }
}

final class SuccessRetriever: ImageRetrievable {
    func retrieveImage(from url: String, failureHandler: ((NetworkError) -> Void)?, imageHandler: @escaping (UIImage?) -> Void) {
        imageHandler(UIImage(named: "sample1"))
    }
}
