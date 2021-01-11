//
//  CurrentPageViewModelTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/11.
//

@testable import PhotoApp
import XCTest

final class CurrentPageViewModelTests: XCTestCase {
    func testBind() {
        let expectation = XCTestExpectation(description: "currentPageViewModel bind success")
        expectation.expectedFulfillmentCount = 3
        let viewModel = CurrentPageViewModel()

        viewModel.bind { _ in
            expectation.fulfill()
        }
        
        viewModel.send(0)
        viewModel.send(0)
        viewModel.send(0)
        viewModel.send(1)
        viewModel.send(1)
        viewModel.send(1)
        viewModel.send(1)
        viewModel.send(2)
        viewModel.send(2)
        
        
        wait(for: [expectation], timeout: 2.0)
    }
}
