//
//  ExpirableObjectTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class ExpirableObjectTests: XCTestCase {
    func testExpire() {
        var expirableObject = ExpirableObject(with: UIImage(), expireTime: .second(3))
        
        sleep(4)
        
        XCTAssertTrue(expirableObject.isExpired)
        
        expirableObject = ExpirableObject(with: UIImage(), expireTime: .second(3))
        
        sleep(2)
        
        XCTAssertFalse(expirableObject.isExpired)
    }
    
    func testResetExpectedExpireTime() {
        let expirableObject = ExpirableObject(with: UIImage(), expireTime: .second(3))
        
        sleep(2)
        expirableObject.resetExpectedExpireDate(.second(3))
        sleep(2)
        
        XCTAssertFalse(expirableObject.isExpired)
    }
}
