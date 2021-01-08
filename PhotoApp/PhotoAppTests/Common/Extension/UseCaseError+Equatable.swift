//
//  UseCaseError+Equatable.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import Foundation

extension UseCaseError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch(lhs, rhs) {
        case (.decodeError(let left), .decodeError(let right)):
            return left == right
        case (.networkError(let left), .networkError(let right)):
            return left == right
        default:
            return false
        }
    }
}
