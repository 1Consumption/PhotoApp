//
//  UseCaseError.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

enum UseCaseError: Error {
    case networkError(description: String)
    case decodeError(description: String)
}
