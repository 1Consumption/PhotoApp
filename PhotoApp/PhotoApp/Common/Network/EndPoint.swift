//
//  EndPoint.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

struct EndPoint {
    init(queryItems: QueryItems) {
        self.queryItems = queryItems
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/photos"
        components.queryItems = queryItems.description
        
        return components.url
    }
    
    private let scheme: String = "https"
    private let host: String = "api.unsplash.com"
    private let queryItems: QueryItems
    
    enum QueryItems {
        case photoList(page: Int)
        
        var description: [URLQueryItem] {
            switch self {
            case .photoList(let page):
                return [URLQueryItem(name: "page", value: "\(page)")]
            }
        }
    }
}
