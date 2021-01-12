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
    
    func testUseCaseErrorOccurred() {
        let failureRequest = InvalidDataRequester()
        let failureManager = NetworkManager(requester: failureRequest)
        let failureViewModel = SearchViewModel(networkManageable: failureManager)
        let expectation = XCTestExpectation(description: "test useCase Error Occured")
        
        let output = failureViewModel.transform(input: input)
        output.errorOccurred.bind {
            XCTAssertEqual(UseCaseError.networkError(networkError: .invalidData), $0)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.sendQuery.value = nil
        input.sendQuery.value = "test"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testIsResultsExist() {
        let expectation = XCTestExpectation(description: "test is results exist")
        expectation.expectedFulfillmentCount = 2
        let emptySearchResult = PhotoSearchResult(results: [])
        let notEmptySearchResult = PhotoSearchResult(results: [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))])
        
        guard let emptyListData = ModelEncoder().encode(with: emptySearchResult) else {
            XCTFail()
            return
        }
       
        let emptyListRequest = SuccessRequester(data: emptyListData)
        let emptyListManager = NetworkManager(requester: emptyListRequest)
        let emptyListViewModel = SearchViewModel(networkManageable: emptyListManager)
        
        let emptyListOutput = emptyListViewModel.transform(input: input)
        emptyListOutput.isResultsExist.bind {
            XCTAssertFalse($0!)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.sendQuery.value = "test"
        
        guard let notEmptyListData = ModelEncoder().encode(with: notEmptySearchResult) else {
            XCTFail()
            return
        }
        
        let notEmptyListRequest = SuccessRequester(data: notEmptyListData)
        let notEmptyListManager = NetworkManager(requester: notEmptyListRequest)
        let notEmptyViewModel = SearchViewModel(networkManageable: notEmptyListManager)
        
        let notEmptyOutput = notEmptyViewModel.transform(input: input)
        notEmptyOutput.isResultsExist.bind {
            XCTAssertTrue($0!)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.sendQuery.value = "test"
        
        wait(for: [expectation], timeout: 2.0)
    }
}
