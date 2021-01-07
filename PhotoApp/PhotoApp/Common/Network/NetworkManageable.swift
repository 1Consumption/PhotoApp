//
//  NetworkManageable.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

typealias DataResultHandler = (Result<Data, NetworkError>) -> Void

protocol NetworkManageable: class {
    var requestBag: Set<URLRequest> { get }
    var requester: Requestable { get }
    
    @discardableResult
    func requestData(from url: URL?, method: HTTPMethod, header: [String: String]?, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask?
    
    func requestCompleted(with url: URLRequest, result: Result<Data, NetworkError>, handler: @escaping DataResultHandler)
}
