//
//  ImageManagerTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class ImageManagerTests: XCTestCase {
    
    private let image = UIImage(named: "sample1")
    private var imageManager: ImageManager!
    private var data: Data!
    
    override func setUpWithError() throws {
        data = image!.jpegData(compressionQuality: 1)
    }
    
    func testRetrievImage() {
        let expectation = XCTestExpectation(description: "retrieveImage")
        expectation.expectedFulfillmentCount = 2
        
        let networkManager = MockSuccessNetworkManager(data: data)
        imageManager = ImageManager(networkManageable: networkManager)
        
        let _ = imageManager.retrieveImage(from: "sample1") { result in
            switch result {
            case .success(let image):
                networkManager.verify(url: URL(string: "sample1"),
                                      method: .get,
                                      header: nil)
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        sleep(2)
        
        let _ = imageManager.retrieveImage(from: "sample1") { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrievImageFailure() {
        let expectation = XCTestExpectation(description: "retrieveImageFailure")
        
        let networkManager = MockFailureNetworkManager(error: .invalidURL)
        imageManager = ImageManager(networkManageable: networkManager)
        
        let _ = imageManager.retrieveImage(from: "sample1") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
