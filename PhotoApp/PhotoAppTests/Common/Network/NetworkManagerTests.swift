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
    
    func testRequestDataSuccess() {
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
    
    func testRequestDataFailureWithError() {
        let expectation = XCTestExpectation(description: "requestFailureWithError")
        
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
}

final class SuccessRequester: Requestable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(Data(), nil, nil)
        return URLSession.shared.dataTask(with: url)
    }
}

final class ReqeustErrorRequester: Requestable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, NetworkError.requestError(description: "error"))
        return URLSession.shared.dataTask(with: url)
    }
}
