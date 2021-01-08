//
//  UseCaseErrorTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class UseCaseErrorTests: XCTestCase {
    func testMessage() {
        var message = UseCaseError.networkError(networkError: .duplicatedRequest).message
        XCTAssertEqual(message, NetworkError.duplicatedRequest.description)
        
        message = UseCaseError.networkError(networkError: .invalidData).message
        XCTAssertEqual(message, NetworkError.invalidData.description)
        
        message = UseCaseError.networkError(networkError: .invalidHTTPResponse).message
        XCTAssertEqual(message, NetworkError.invalidHTTPResponse.description)
        
        message = UseCaseError.networkError(networkError: .invalidStatusCode(with: 300)).message
        XCTAssertEqual(message, NetworkError.invalidStatusCode(with: 300).description)
        
        message = UseCaseError.networkError(networkError: .invalidURL).message
        XCTAssertEqual(message, NetworkError.invalidURL.description)
        
        message = UseCaseError.networkError(networkError: .requestError(description: "error")).message
        XCTAssertEqual(message, NetworkError.requestError(description: "error").description)
        
        message = UseCaseError.decodeError(description: "decodeError").message
        XCTAssertEqual(message, "decodeError")
    }
}
