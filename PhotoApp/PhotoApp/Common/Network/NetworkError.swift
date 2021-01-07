//
//  NetworkError.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

enum NetworkError: Error {
    case requestError(description: String)
    var localizedDescription: String {
        switch self {
        case .requestError(let description):
            return description
        }
    }
}
