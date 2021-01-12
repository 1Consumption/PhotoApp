//
//  IsEditingViewModelTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/12.
//

@testable import PhotoApp
import XCTest

final class IsEditingViewModelTests: XCTestCase {
    func testBind() {
        let expectation = XCTestExpectation(description: "bind Success")
        expectation.expectedFulfillmentCount = 2
        let isEditingViewModel = IsEditingViewModel()
        
        isEditingViewModel.bind { _ in
            expectation.fulfill()
        }
        
        isEditingViewModel.send(state: false)
        isEditingViewModel.send(state: true)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
