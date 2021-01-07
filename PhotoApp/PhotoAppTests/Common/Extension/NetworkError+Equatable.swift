//
//  NetworkError+Equatable.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/07.
//

@testable import PhotoApp
import Foundation

extension NetworkError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.requestError(_), .requestError(_)):
            return true
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidHTTPResponse, .invalidHTTPResponse):
            return true
        case (.invalidStatusCode(let left), .invalidStatusCode(let right)):
            return left == right
        default:
            return false
        }
    }
}

