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
        var endPoint = EndPoint(urlInfomation: .photoList(page: 1))
        XCTAssertEqual(endPoint.url, URL(string: "https://api.unsplash.com/photos?page=1"))
        
        endPoint = EndPoint(urlInfomation: .search(query: "office", page: 1))
        XCTAssertEqual(endPoint.url, URL(string: "https://api.unsplash.com/search/photos?query=office&page=1"))
    }
}
