//
//  MemoryCacheStorageTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class MemoryCacheStorageTests: XCTestCase {

    func testMemoryStorageInsert() {
        let photo = Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(3))
        
        memoryCacheStorage.insert(photo, for: "Key")
        
        XCTAssertEqual(photo, memoryCacheStorage.object(for: "Key"))
        XCTAssertNil(memoryCacheStorage.object(for: "Key2"))
    }
}
