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
        networkManager.requestData(from: URL(string: "success"),
                                   method: .get, header: nil,
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
        failureCase(description: "error",
                    requester: RequestErrorRequester(),
                    networkError: .requestError(description: "error"))
    }
    
    func testFailureWithInvalidURL() {
        failureCase(description: "invalidURL",
                    requester: SuccessRequester(),
                    path: "",
                    networkError: .invalidURL)
    }
    
    func testFailiureWithInvalidHTTPResponse() {
        failureCase(description: "invalidHTTPResponse",
                    requester: InvalidHTTPResponseRequester(),
                    networkError: .invalidHTTPResponse)
    }
    
    func testFailureWithInvalidStatusCode() {
        failureCase(description: "invalidStatusCode",
                    requester: InvalidStatusCode(),
                    networkError: .invalidStatusCode(with: 300))
    }
    
    func testFailureWithInvalidData() {
        failureCase(description: "invalidData",
                    requester: InvalidData(),
                    networkError: .invalidData)
    }
    
    func testFailureWithDuplicatedRequest() {
        let invalidExpectation = XCTestExpectation(description: "invalid")
        let duplicateExpectation = XCTestExpectation(description: "duplicate")
        
        let duplicate = DuplicateRequest()
        duplicate.delayTime = 3
        let manager = NetworkManager(requester: duplicate)
        
        manager.requestData(from: URL(string: "duplicate"),
                                   method: .get,
                                   completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, .invalidData)
                                        invalidExpectation.fulfill()
                                    }
                                   })
        
        duplicate.delayTime = 0
        
        manager.requestData(from: URL(string: "duplicate"),
                                   method: .get,
                                   completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, .duplicatedRequest)
                                        duplicateExpectation.fulfill()
                                    }
                                   })
        
        wait(for: [invalidExpectation, duplicateExpectation], timeout: 5.0)
    }
    
    private func failureCase(description: String, requester: Requestable, path: String = "failure", networkError: NetworkError, time: TimeInterval = 0) {
        let expectation = XCTestExpectation(description: description)
        
        networkManager = NetworkManager(requester: requester)
        networkManager.requestData(from: URL(string: path),
                                   method: .get,header: nil,
                                   completionHandler: { result in
                                    switch result {
                                    case .success(_):
                                        XCTFail()
                                    case .failure(let error):
                                        XCTAssertEqual(error, networkError)
                                        expectation.fulfill()
                                    }
                                   })

        wait(for: [expectation], timeout: 5.0)
    }
}

final class SuccessRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(Data(), HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class RequestErrorRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, NetworkError.requestError(description: "error"))
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidHTTPResponseRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, URLResponse(), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidStatusCode: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, HTTPURLResponse(url: urlRequest.url!, statusCode: 300, httpVersion: nil, headerFields: nil), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidData: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class DuplicateRequest: Requestable {
    private let queue = DispatchQueue(label: "duplicated")
    var delayTime = 0
    
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        queue.asyncAfter(deadline: .now() + .seconds(delayTime), execute: {
            completionHandler(nil, HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        })
        return URLSession.shared.dataTask(with: urlRequest)
    }
}
