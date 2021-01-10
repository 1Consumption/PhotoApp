//
//  ExpireTimeTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class ExpireTimeTests: XCTestCase {
    func testExpireTime() {
        XCTAssertEqual(ExpireTime.second(3).timeInterval, 3)
        XCTAssertEqual(ExpireTime.minute(2).timeInterval, 120)
    }
}
