//
//  PhotoListUseCaseTests.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import XCTest

final class PhotoListUseCaseTests: XCTestCase {
    func testSuccess() {
        let expectation = XCTestExpectation(description: "success")
        
        let photo = [Photo(id: "1", width: 0, height: 0, urls: URLs(full: "", regular: ""), user: User(name: "name"))]
        guard let encoded = ModelEncoder().encode(with: photo) else {
            XCTFail()
            return
        }
        
        let networkManager = NetworkManager(requester: SuccessRequester(data: encoded))
        let useCase = PhotoListUseCase(networkManageable: networkManager)
        
        useCase.retrievePhotoList(
            failureHandler: { _ in
                XCTFail()
            },
            successHandler: {
                let retrievedPhoto = $0
                XCTAssertEqual(photo, retrievedPhoto)
                XCTAssertEqual(useCase.page, 2)
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 5.0)
    }
}

extension Photo: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(urls, forKey: .urls)
        try container.encode(user, forKey: .user)
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case width
        case height
        case urls
        case user
    }
}

extension Photo: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension URLs: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(full, forKey: .full)
        try container.encode(regular, forKey: .regular)
    }
    
    enum CodingKeys: String, CodingKey{
        case full
        case regular
    }
}

extension User: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
    
    enum CodingKeys: String, CodingKey{
        case name
    }
}
