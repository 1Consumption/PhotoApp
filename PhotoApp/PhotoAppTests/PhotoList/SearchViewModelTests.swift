//
//  SearchViewModelTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/12.
//

@testable import PhotoApp
import XCTest

final class SearchViewModelTests: XCTestCase {
    private let input = SearchViewModelInput()
    private let viewModel = SearchViewModel()
    private lazy var output = viewModel.transform(input: input)
    private var bag: CancellableBag = CancellableBag()
    
    func testBindTextFieldEditBegan() {
        let expectation = XCTestExpectation(description: "test bind text field edit began")
        
        output.textFieldEditBegan.bind {
            XCTAssertFalse($0!)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.textFieldEditBegan.fire()

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testBindCancelButtonPushed() {
        let expectation = XCTestExpectation(description: "test bind text field edit began")
        
        output.cancelButtonPushed.bind {
            XCTAssertTrue($0!)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.cancelButtonPushed.fire()

        wait(for: [expectation], timeout: 1.0)
    }
}
