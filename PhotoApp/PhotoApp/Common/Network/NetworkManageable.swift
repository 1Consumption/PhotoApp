//
//  NetworkManageable.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

typealias DataResultHandler = (Result<Data, NetworkError>) -> Void

protocol NetworkManageable: class {
    var requestBag: Set<URL> { get }
    var requester: Requestable { get }
    
    @discardableResult
    func requestData(from url: String, method: HTTPMethod, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask?
    
    func requestCompleted(with url: URL, result: Result<Data, NetworkError>, handler: @escaping DataResultHandler)
}
