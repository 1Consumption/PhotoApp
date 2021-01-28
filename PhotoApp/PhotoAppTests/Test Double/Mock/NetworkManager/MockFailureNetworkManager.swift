//
//  MockFailureNetworkManager.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/28.
//

@testable import PhotoApp
import XCTest

final class MockFailureNetworkManager: NetworkManageable {
    
    var requester: Requestable
    
    private var url: URL?
    private var method: HTTPMethod?
    private var header: [HTTPHeader]?
    private var callCount: Int = 0
    
    private var error: NetworkError
    
    init(error: NetworkError = .invalidData) {
        requester = DummyRequester()
        self.error = error
    }
    
    func requestData(from url: URL?, method: HTTPMethod, header: [HTTPHeader]?, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask? {
        self.url = url
        self.method = method
        self.header = header
        self.callCount += 1
        
        completionHandler(.failure(error))
        
        return nil
    }
    
    func verify(url: URL?, method: HTTPMethod, header: [HTTPHeader]?, callCount: Int = 1) {
        XCTAssertEqual(self.url, url)
        XCTAssertEqual(self.method, method)
        XCTAssertEqual(self.header, header)
        XCTAssertEqual(self.callCount, callCount)
    }
}
