//
//  PhotoSearchResult+Equatable.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/12.
//

@testable import PhotoApp
import Foundation

extension PhotoSearchResult: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results, forKey: .results)
    }
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

extension PhotoSearchResult: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.results == rhs.results
    }
}
