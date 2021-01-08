//
//  HTTPHeaderTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import XCTest

final class HTTPHeaderTests: XCTestCase {
    func testHeader() {
        let auth = HTTPHeader.authorization(key: "key")
        XCTAssertEqual(auth.header, ["Authorization": "key"])
    }
}
