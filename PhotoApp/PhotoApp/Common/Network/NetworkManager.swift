//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

final class NetworkManager: NetworkManageable {
    private(set) var requestBag: Set<URL> = Set<URL>()
    private(set) var requester: Requestable
    
    init(requester: Requestable) {
        self.requester = requester
    }
    
    func requestData(from url: String, method: HTTPMethod, completionHandler: @escaping DataResultHandler) -> URLSessionDataTask? {
        guard let url = URL(string: url) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        
        let dataTask = requester.dataTask(with: url) { data , response, error in
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
    
    func requestCompleted() {
        
    }
}
