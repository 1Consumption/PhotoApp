//
//  MemoryCacheStorageTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class MemoryCacheStorageTests: XCTestCase {
    private let photos = [
        Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "")),
        Photo(id: "2", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "")),
        Photo(id: "3", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "")),
        Photo(id: "4", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))
    ]
    
    func testMemoryStorageInsert() {
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(3))
        
        memoryCacheStorage.insert(photos[0], for: "Key")
        
        XCTAssertEqual(photos[0], memoryCacheStorage.object(for: "Key"))
        XCTAssertNil(memoryCacheStorage.object(for: "Key2"))
    }
    
    func testMemoryStorageRemove() {
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(3))
        
        memoryCacheStorage.insert(photos[0], for: "Key")

        memoryCacheStorage.removeObject(for: "Key")
        XCTAssertNil(memoryCacheStorage.object(for: "Key"))
    }
    
    func testMemoryStorageRemoveAllObjects() {
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(3))
        
        photos.forEach {
            memoryCacheStorage.insert($0, for: $0.id)
        }
        
        memoryCacheStorage.removeAllObjects()
        
        photos.forEach {
            XCTAssertNil(memoryCacheStorage.object(for: $0.id))
        }
    }
}
