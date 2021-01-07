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
        var description = NetworkError.requestError(description: "reqeustError").localizedDescription
        XCTAssertEqual(description, "reqeustError")
        
        description = NetworkError.invalidURL.localizedDescription
        XCTAssertEqual(description, "invalid URL!")
    }
}
