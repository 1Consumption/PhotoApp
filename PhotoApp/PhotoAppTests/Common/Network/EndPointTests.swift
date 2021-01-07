//
//  EndPointTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import XCTest

final class EndPointTests: XCTestCase {
    
    func testURL() {
        let endPoint = EndPoint(queryItems: .photoList(page: 1))
        XCTAssertEqual(endPoint.url, URL(string: "https://api.unsplash.com/photos?page=1"))
    }
}
