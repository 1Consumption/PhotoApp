//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

final class NetworkManager: NetworkManageable {
    private(set) var requester: Requestable
    private var isLoading: Bool = false
    
    init(requester: Requestable = DefaultRequester()) {
        self.requester = requester
    }
    
    @discardableResult
    func requestData(from url: URL?, isPermitDuplicate: Bool = false, method: HTTPMethod, header: [HTTPHeader]? = nil, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask? {
        guard let urlRequest = makeURLRequest(url: url, method: method, headers: header) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        
        if isPermitDuplicate == false {
            guard !isLoading else {
                completionHandler(.failure(.duplicatedRequest))
                return nil
            }
            isLoading = true
        }
        
        let dataTask = requester.dataTask(with: urlRequest) { data , response, error in
            guard error == nil else {
                self.requestCompleted(with: urlRequest,
                                      result: .failure(.requestError(description: error!.localizedDescription)),
                                      handler: completionHandler)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.requestCompleted(with: urlRequest,
                                      result: .failure(.invalidHTTPResponse),
                                      handler: completionHandler)
                return
            }
            
            guard (200...299) ~= httpResponse.statusCode else {
                self.requestCompleted(with: urlRequest,
                                      result: .failure(.invalidStatusCode(with: httpResponse.statusCode)),
                                      handler: completionHandler)
                return
            }
            
            guard let data = data else {
                self.requestCompleted(with: urlRequest,
                                      result: .failure(.invalidData),
                                      handler: completionHandler)
                return
            }
            
            self.requestCompleted(with: urlRequest,
                                  result: .success(data),
                                  handler: completionHandler)
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
    func requestCompleted(with url: URLRequest, result: Result<Data, NetworkError>, handler: @escaping DataResultHandler) {
        isLoading = false
        handler(result)
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
