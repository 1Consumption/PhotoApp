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
    
    func testRemoveExpiredObjects() {
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(2))
        
        memoryCacheStorage.insert(photos[0], for: photos[0].id)
        sleep(3)
        memoryCacheStorage.insert(photos[1], for: photos[1].id)
        memoryCacheStorage.removeExpiredObjects()
        
        XCTAssertNil(memoryCacheStorage.object(for: photos[0].id))
        XCTAssertEqual(photos[1], memoryCacheStorage.object(for: photos[1].id))
    }
    
    func testResetExpireTime() {
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(3))
        
        memoryCacheStorage.insert(photos[0], for: photos[0].id)
        memoryCacheStorage.insert(photos[1], for: photos[1].id)
        sleep(2)
        _ = memoryCacheStorage.object(for: photos[0].id)
        sleep(2)
        
        memoryCacheStorage.removeExpiredObjects()
        
        XCTAssertNotNil(memoryCacheStorage.object(for: photos[0].id))
        XCTAssertNil(memoryCacheStorage.object(for: photos[1].id))
    }
    
    func testReceiveMemoryWarning() {
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(2))
        
        memoryCacheStorage.insert(photos[0], for: photos[0].id)
        sleep(2)
        memoryCacheStorage.insert(photos[1], for: photos[1].id)
        
        NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification,
                                        object: nil)
        
        XCTAssertNotNil(memoryCacheStorage.object(for: photos[1].id))
        XCTAssertNil(memoryCacheStorage.object(for: photos[0].id))
    }
    
    func testReferenceExpiredValue() {
        let memoryCacheStorage = MemoryCacheStorage<Photo>(size: 10, expireTime: .second(2))
        
        memoryCacheStorage.insert(photos[0], for: photos[0].id)
        sleep(3)
        
        XCTAssertNil(memoryCacheStorage.object(for: photos[0].id))
    }
}
