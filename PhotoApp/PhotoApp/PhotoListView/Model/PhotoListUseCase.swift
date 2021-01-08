//
//  PhotoListUseCase.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

final class PhotoListUseCase: RemoteDataDecodableType {
    private(set) var page: Int = 1
    let networkManager: NetworkManageable
    
    init(networkManageable: NetworkManager = NetworkManager()) {
        self.networkManager = networkManageable
    }
    
    func retrievePhotoList(failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping ([Photo]) -> Void) {
        let url = EndPoint(queryItems: .photoList(page: page)).url
        retrieveModel(from: url,
                      failureHandler: failureHandler,
                      modelWillDeliverHandler: { [weak self] in self?.page += 1 },
                      successHandler: successHandler)
    }
}

