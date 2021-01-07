//
//  NetworkErrorTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/07.
//

@testable import PhotoApp
import XCTest

final class NetworkErrorTests: XCTestCase {
    
    func testLocalizedDescription() {
        var description = NetworkError.requestError(description: "requestError").description
        XCTAssertEqual(description, "requestError")
        
        description = NetworkError.invalidURL.description
        XCTAssertEqual(description, "invalid URL!")
        
        description = NetworkError.invalidHTTPResponse.description
        XCTAssertEqual(description, "invalid HTTPResponse!")
        
        description = NetworkError.invalidStatusCode(with: 300).description
        XCTAssertEqual(description, "invalid statusCode: 300")
        
        description = NetworkError.invalidData.description
        XCTAssertEqual(description, "invalid data")
        
        description = NetworkError.duplicatedRequest.description
        XCTAssertEqual(description, "duplicated request")
    }
}
