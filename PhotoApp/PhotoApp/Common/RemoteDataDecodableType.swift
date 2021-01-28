//
//  RemoteDataDecodableType.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

protocol RemoteDataDecodableType {
    associatedtype T: Decodable
    
    var networkManager: NetworkManageable { get }
    
    func retrieveModel(from url: URL?,
                                     completionHandler: @escaping (Result<T, UseCaseError>) -> Void)
}

extension RemoteDataDecodableType {
    func retrieveModel(from url: URL?, completionHandler: @escaping (Result<T, UseCaseError>) -> Void) {
        networkManager.requestData(from: url,
                                   method: .get,
                                   header: [.authorization(key: Secret.APIKey)],
                                   completionHandler: {
                                    let result = $0.flatMapError { error -> Result<Data, UseCaseError> in
                                        return .failure(.networkError(networkError: error))
                                    }.flatMap { data -> Result<T, UseCaseError> in
                                        do {
                                            let model = try JSONDecoder().decode(T.self, from: data)
                                            return .success(model)
                                        } catch {
                                            return .failure(.decodeError)
                                        }
                                    }
                                    
                                    completionHandler(result)
                                   })
    }
}
