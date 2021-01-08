//
//  NetworkError.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

enum NetworkError: Error {
    case requestError(description: String)
    case invalidURL
    case invalidHTTPResponse
    case invalidStatusCode(with: Int)
    case invalidData
    case duplicatedRequest
    
    var description: String {
        switch self {
        case .requestError(let description):
            return description
        case .invalidURL:
            return "invalid URL!"
        case .invalidHTTPResponse:
            return "invalid HTTPResponse!"
        case .invalidStatusCode(let code):
            return "invalid statusCode: \(code)"
        case .invalidData:
            return "invalid data"
        case .duplicatedRequest:
            return "duplicated request"
        }
    }
}
