//
//  PhotoListTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/09.
//

@testable import PhotoApp
import XCTest

final class PhotoListTests: XCTestCase {
    private var photoList: PhotoList = PhotoList()
    
    func testAppend() {
        let photos = [
            Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "")),
            Photo(id: "2", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "")),
            Photo(id: "3", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))
        ]
        
        photoList.append(contentsOf: photos)
        XCTAssertEqual(photos.count, photoList.count)
        
        let photo = Photo(id: "4", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))
        
        photoList.append(photo)
        XCTAssertEqual(4, photoList.count)
    }
    
    func testPhoto() {
        let photos = [
            Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "")),
            Photo(id: "2", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "")),
            Photo(id: "3", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: ""))
        ]
        
        photoList.append(contentsOf: photos)
        
        XCTAssertEqual(photos[0], photoList.photo(of: 0))
        XCTAssertNil(photoList.photo(of: photos.count))
    }
}
