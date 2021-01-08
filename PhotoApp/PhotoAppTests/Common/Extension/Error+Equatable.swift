//
//  Error+Equatable.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//
@testable import PhotoApp
import Foundation

extension Error {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
