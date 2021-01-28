//
//  NetworkManageable.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

typealias DataResultHandler = (Result<Data, NetworkError>) -> Void

protocol NetworkManageable: class {
    var requester: Requestable { get }
    
    @discardableResult
    func requestData(from url: URL?, method: HTTPMethod, header: [HTTPHeader]?, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask?
}
