//
//  HTTPHeader.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

enum HTTPHeader {
    case authorization(key: String)
    
    var header: [String: String] {
        switch self {
        case .authorization(let key):
            return ["Authorization": key]
        }
    }
}
