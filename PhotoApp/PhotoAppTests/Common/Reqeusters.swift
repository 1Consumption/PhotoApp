//
//  Reqeusters.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import Foundation

final class SuccessRequester: Requestable {
    private let data: Data
    
    init(data: Data = Data()) {
        self.data = data
    }
    
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class RequestErrorRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, nil, NetworkError.requestError(description: "error"))
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidHTTPResponseRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, URLResponse(), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidStatusCodeReqeuster: Requestable {
    private let code: Int
    
    init(with code: Int = 300) {
        self.code = code
    }
    
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, HTTPURLResponse(url: urlRequest.url!, statusCode: code, httpVersion: nil, headerFields: nil), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class InvalidDataRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        return URLSession.shared.dataTask(with: urlRequest)
    }
}

final class DuplicateRequest: Requestable {
    private let queue = DispatchQueue(label: "duplicated")
    var delayTime = 0
    
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        queue.asyncAfter(deadline: .now() + .seconds(delayTime), execute: {
            completionHandler(nil, HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        })
        return URLSession.shared.dataTask(with: urlRequest)
    }
}
