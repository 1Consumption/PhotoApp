//
//  Photos+Equatable+Encodable.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import Foundation

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
