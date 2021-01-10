//
//  CancellableTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/10.
//

@testable import PhotoApp
import XCTest

final class CancellableTests: XCTestCase {
    func testCancelWhenCallingCancelMethod() {
        let expectation = XCTestExpectation(description: "cancelable")
        
        let cancelable: Cancellable? = Cancellable {
            expectation.fulfill()
        }
        
        cancelable?.cancel()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testCancelWhenCancelableDeinitialized() {
        let expectation = XCTestExpectation(description: "cancelable")
        
        var cancelable: Cancellable? = Cancellable {
            expectation.fulfill()
        }
        
        XCTAssertNotNil(cancelable)
        
        cancelable = nil
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testStore() {
        var bag = CancellableBag()
        let cancelable: Cancellable = Cancellable({ })
        cancelable.store(in: &bag)
        
        XCTAssertTrue(bag.contains(cancelable))
    }
}
