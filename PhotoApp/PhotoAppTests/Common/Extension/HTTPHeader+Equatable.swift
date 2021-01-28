//
//  HTTPHeader+Equatable.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/28.
//

@testable import PhotoApp
import Foundation

extension HTTPHeader: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.header == rhs.header
    }
}
