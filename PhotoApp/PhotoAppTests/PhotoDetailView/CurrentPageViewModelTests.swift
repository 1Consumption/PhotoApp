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
        let viewModel: CurrentPageViewModel = CurrentPageViewModel()
        let viewModelInput: CurrentPageViewModelInput = CurrentPageViewModelInput()
        var bag: CancellableBag = CancellableBag()
        
        let output = viewModel.transform(input: viewModelInput)
        
        output.index.bind { _ in
            expectation.fulfill()
        }.store(in: &bag)
        
        viewModelInput.page.value = 0
        viewModelInput.page.value = 0
        viewModelInput.page.value = 0
        viewModelInput.page.value = 1
        viewModelInput.page.value = 1
        viewModelInput.page.value = 1
        viewModelInput.page.value = 1
        viewModelInput.page.value = 2
        viewModelInput.page.value = 2
        
        wait(for: [expectation], timeout: 2.0)
    }
}
