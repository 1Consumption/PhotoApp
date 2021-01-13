//
//  ImageManagerTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class ImageManagerTests: XCTestCase {
    func testRetrievImage() {
        let expectation = XCTestExpectation(description: "retrieveImage")
        expectation.expectedFulfillmentCount = 4
        let image = UIImage(named: "sample1")
        guard let data = image?.jpegData(compressionQuality: 1) else {
            XCTFail()
            return
        }
        
        let requester = SuccessRequester(data: data)
        let networkManager = NetworkManager(requester: requester)
        let imageManager = ImageManager(networkManageable: networkManager)
        
        imageManager.retrieveImage(from: "sample1", dataTaskHandler: {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }) {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }
        
        sleep(2)
        
        imageManager.retrieveImage(from: "sample1", dataTaskHandler: {
            XCTAssertNil($0)
            expectation.fulfill()
        }) {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrievImageFailure() {
        let expectation = XCTestExpectation(description: "retrieveImageFailure")
        
        let requester = InvalidDataRequester()
        let networkManager = NetworkManager(requester: requester)
        let imageManager = ImageManager(networkManageable: networkManager)
        
        imageManager.retrieveImage(from: "sample1", dataTaskHandler: { _ in }, failureHandler: { _ in
            expectation.fulfill()
        }) { _ in
            XCTFail()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
