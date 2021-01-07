//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

final class NetworkManager: NetworkManageable {
    private(set) var requestBag: Set<URLRequest> = Set<URLRequest>()
    private(set) var requester: Requestable
    
    init(requester: Requestable = DefaultRequester()) {
        self.requester = requester
    }
    
    @discardableResult
    func requestData(from url: URL?, method: HTTPMethod, header: [String: String]? = nil, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask? {
        guard let url = makeURLRequest(url: url, method: method, headers: header) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        
        guard !requestBag.contains(url) else {
            completionHandler(.failure(.duplicatedRequest))
            return nil
        }
        
        requestBag.insert(url)
        
        let dataTask = requester.dataTask(with: url) { data , response, error in
            guard error == nil else {
                self.requestCompleted(with: url,
                                      result: .failure(.requestError(description: error!.localizedDescription)),
                                      handler: completionHandler)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.requestCompleted(with: url,
                                      result: .failure(.invalidHTTPResponse),
                                      handler: completionHandler)
                return
            }
            
            guard (200...299) ~= httpResponse.statusCode else {
                self.requestCompleted(with: url,
                                      result: .failure(.invalidStatusCode(with: httpResponse.statusCode)),
                                      handler: completionHandler)
                return
            }
            
            guard let data = data else {
                self.requestCompleted(with: url,
                                      result: .failure(.invalidData),
                                      handler: completionHandler)
                return
            }
            
            self.requestCompleted(with: url,
                                  result: .success(data),
                                  handler: completionHandler)
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    func requestCompleted(with url: URLRequest, result: Result<Data, NetworkError>, handler: @escaping DataResultHandler) {
        requestBag.remove(url)
        handler(result)
    }
    
    private func makeURLRequest(url: URL?, method: HTTPMethod, headers: [String: String]?) -> URLRequest? {
        guard let url = url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        headers?.forEach { field, value in
            urlRequest.addValue(value, forHTTPHeaderField: field)
        }
        
        return urlRequest
    }
    
    deinit {
        requestBag = Set<URLRequest>()
    }
}

final class DefaultRequester: Requestable {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    }
}
