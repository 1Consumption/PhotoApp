//
//  RemoteDataDecodableType.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

protocol RemoteDataDecodableType {
    var networkManager: NetworkManageable { get }
    
    func retrieveModel<T: Decodable>(from url: URL?,
                                     modelWillDeliverHandler: (() -> Void)?,
                                     completionHandler: @escaping (Result<T, UseCaseError>) -> Void)
}

extension RemoteDataDecodableType {
    func retrieveModel<T: Decodable>(from url: URL?, modelWillDeliverHandler: (() -> Void)?, completionHandler: @escaping (Result<T, UseCaseError>) -> Void) {
        networkManager.requestData(from: url,
                                   isPermitDuplicate: false,
                                   method: .get,
                                   header: [.authorization(key: Secret.APIKey)],
                                   completionHandler: {
                                    let result = $0.flatMapError { error -> Result<Data, UseCaseError> in
                                        return .failure(.networkError(networkError: error))
                                    }.flatMap { data -> Result<T, UseCaseError> in
                                        do {
                                            let model = try JSONDecoder().decode(T.self, from: data)
                                            modelWillDeliverHandler?()
                                            return .success(model)
                                        } catch {
                                            return .failure(.decodeError)
                                        }
                                    }
                                    
                                    completionHandler(result)
                                   })
    }
}
