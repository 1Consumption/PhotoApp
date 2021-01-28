//
//  PhotoListViewModelTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import XCTest

final class PhotoListViewModelTests: XCTestCase {
    private var bag: CancellableBag = CancellableBag()
    private let input: PhotoListViewModelInput = PhotoListViewModelInput()
    func testBind() {
        var range = (0..<1).map { IndexPath(item: $0, section: 0) }
        let maxCount = 3
        let photo = [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))]
       
        let encoded = try! JSONEncoder().encode(photo)
        
        let requester = SuccessRequester(data: encoded)
        let networkManager = NetworkManager(requester: requester)
        let photoListViewModel = PhotoListViewModel(networkManageable: networkManager)
        
        let expectation = XCTestExpectation(description: "changedIndexPath")
        expectation.expectedFulfillmentCount = maxCount
        
        let output = photoListViewModel.transfrom(input)
        
        output.changedIndexPath.bind {
            XCTAssertEqual(range, $0!)
            XCTAssertEqual(photo[0], photoListViewModel.photo(of: range.min()!.item))
            range = (range.max()!.item + 1..<range.max()!.item + 2).map { IndexPath(item: $0, section: 0) }
            expectation.fulfill()
        }.store(in: &bag)
        
        (0..<maxCount).forEach { _ in
            input.sendEvent.fire()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testErrorOccured() {
        let networkManager = NetworkManager(requester: InvalidDataRequester())
        let photoListViewModel = PhotoListViewModel(networkManageable: networkManager)
        let expectation = XCTestExpectation(description: "failureWithNetworkError")
        
        let output = photoListViewModel.transfrom(input)
        
        output.errorOccurred.bind {
            XCTAssertEqual(.networkError(networkError: .invalidData), $0!)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.sendEvent.fire()

        wait(for: [expectation], timeout: 5.0)
    }
}

