//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

final class NetworkManager: NetworkManageable {
    private(set) var requester: Requestable
    
    init(requester: Requestable = DefaultRequester()) {
        self.requester = requester
    }
    
    @discardableResult
    func requestData(from url: URL?, method: HTTPMethod, header: [HTTPHeader]? = nil, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask? {
        guard let urlRequest = makeURLRequest(url: url, method: method, headers: header) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        
        let dataTask = requester.dataTask(with: urlRequest) { data , response, error in
            guard error == nil else {
                completionHandler(.failure(.requestError(description: error!.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.invalidHTTPResponse))
                return
            }
            
            guard (200...299) ~= httpResponse.statusCode else {
                completionHandler(.failure(.invalidStatusCode(with: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    private func makeURLRequest(url: URL?, method: HTTPMethod, headers: [HTTPHeader]?) -> URLRequest? {
        guard let url = url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach {
            $0.header.forEach { field, value in
                urlRequest.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        return urlRequest
    }
}

final class DefaultRequester: Requestable {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    }
}

final class ImageRequster: Requestable {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession(configuration: .ephemeral).dataTask(with: url, completionHandler: completionHandler)
    }
}
