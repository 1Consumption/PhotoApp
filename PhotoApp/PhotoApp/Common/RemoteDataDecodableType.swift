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
                                     failureHandler: @escaping (UseCaseError) -> Void,
                                     modelWillDeliverHandler: (() -> Void)?,
                                     successHandler: @escaping (T) -> Void)
}

extension RemoteDataDecodableType {
    func retrieveModel<T: Decodable>(
        from url: URL?,
        failureHandler: @escaping (UseCaseError) -> Void,
        modelWillDeliverHandler: (() -> Void)? = nil,
        successHandler: @escaping (T) -> Void) {
        networkManager.requestData(from: url,
                                   method: .get,
                                   header: [.authorization(key: Secret.APIKey)],
                                   completionHandler: {
                                    switch $0 {
                                    case .success(let data):
                                        do {
                                            let model = try JSONDecoder().decode(T.self, from: data)
                                            modelWillDeliverHandler?()
                                            successHandler(model)
                                        } catch {
                                            failureHandler(.decodeError(description: error.localizedDescription))
                                        }
                                    case .failure(let networkError):
                                        failureHandler(.networkError(networkError: networkError))
                                    }
                                   })
    }
}
