//
//  ObservableTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class ObservableTests: XCTestCase {
    func testBind() {
        let expectation = XCTestExpectation(description: "observable bind")
        let number = 5
        let observable = Observable<Int>()
        observable.bind {
            XCTAssertEqual(number, $0)
            expectation.fulfill()
        }
        
        observable.value = number
        
        wait(for: [expectation], timeout: 1.0)
    }
}
