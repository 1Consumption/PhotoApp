//
//  EndPoint.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

struct EndPoint {
    init(urlInfomation: URLInfomation) {
        self.urlInfomation = urlInfomation
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = urlInfomation.path
        components.queryItems = urlInfomation.queryItems
        
        return components.url
    }
    
    private let scheme: String = "https"
    private let host: String = "api.unsplash.com"
    private let urlInfomation: URLInfomation
    
    enum URLInfomation {
        case photoList(page: Int)
        case search(query: String, page: Int)
        
        var path: String {
            switch self {
            case .photoList(_):
                return "/photos"
            case .search(_, _):
                return "/search/photos"
            }
        }
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .photoList(let page):
                return [URLQueryItem(name: "page", value: "\(page)")]
            case .search(let query, let page):
                return [URLQueryItem(name: "query", value: query), URLQueryItem(name: "page", value: "\(page)")]
            }
        }
    }
}
