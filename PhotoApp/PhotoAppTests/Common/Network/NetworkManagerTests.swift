//
//  NetworkManagerTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/07.
//

@testable import PhotoApp
import XCTest

final class NetworkManagerTests: XCTestCase {
    private var networkManager: NetworkManageable!
    
    func testSuccess() {
        let expectation = XCTestExpectation(description: "requestSuccess")
        var resultData: Data?
        
        networkManager = NetworkManager(requester: SuccessRequester())
        networkManager.requestData(from: "success",
                                   method: .get,
                                   completionHandler: { result in
                                    switch result {
                                    case .success(let data):
                                        resultData = data
                                        expectation.fulfill()
                                    case .failure(_):
                                        XCTFail()
                                    }
                                   })

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(resultData)
    }
    
    func testFailureWithError() {
        let expectation = XCTestExpectation(description: "rrror")
        
        networkManager = NetworkManager(requester: ReqeustErrorRequester())
        networkManager.requestData(from: "requestError",
                                   method: .get,
                                   completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, NetworkError.requestError(description: "error"))
                                        expectation.fulfill()
                                    }
                                   })

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailureWithInvalidURL() {
        let expectation = XCTestExpectation(description: "invalidURL")
        
        networkManager = NetworkManager(requester: SuccessRequester())
        networkManager.requestData(from: "",
                                   method: .get,
                                   completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, NetworkError.invalidURL)
                                        expectation.fulfill()
                                    }
                                   })

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFailiureWithInvalidHTTPResponse() {
        let expectation = XCTestExpectation(description: "invalidHTTPResponse")
        
        networkManager = NetworkManager(requester: InvalidHTTPResponseRequester())
        networkManager.requestData(from: "invalidHTTPResponse",
                                   method: .get,
                                   completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, NetworkError.invalidHTTPResponse)
                                        expectation.fulfill()
                                    }
                                   })

        wait(for: [expectation], timeout: 5.0)
    }
}

final class SuccessRequester: Requestable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(Data(), HTTPURLResponse(), nil)
        return URLSession.shared.dataTask(with: url)
    }
}

final class ReqeustErrorRequester: Requestable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, NetworkError.requestError(description: "error"))
        return URLSession.shared.dataTask(with: url)
    }
}

final class InvalidHTTPResponseRequester: Requestable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, URLResponse(), nil)
        return URLSession.shared.dataTask(with: url)
    }
}
