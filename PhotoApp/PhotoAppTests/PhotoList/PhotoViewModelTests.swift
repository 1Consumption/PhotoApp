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
        let viewModelInput = PhotoViewModelInput()
        var bag = CancellableBag()
        
        let output = viewModel.transform(input: viewModelInput)
        
        output.receivedImage.bind {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }.store(in: &bag)
        
        viewModelInput.sendEvent.fire()
        
        wait(for: [expectation], timeout: 5.0)
    }
}

final class SuccessRetriever: ImageRetrievable {
    func retrieveImage(from url: String, completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void) -> Cancellable? {
        
        completionHandler(.success(UIImage(named: "sample1")))
        
        return nil
    }
}
