//
//  PhotoListUseCase.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

final class PhotoListUseCase: RemoteDataDecodableType {
    typealias T = [Photo]
    private(set) var page: Int = 1
    private var isLoading: Bool = false
    let networkManager: NetworkManageable
    
    init(networkManageable: NetworkManageable) {
        self.networkManager = networkManageable
    }
    
    func retrievePhotoList(completionHandler: @escaping (Result<[Photo], UseCaseError>) -> Void) {
        guard !isLoading else {
            completionHandler(.failure(.duplicatedRequest))
            return
        }
        
        isLoading = true
        
        let url = EndPoint(urlInfomation: .photoList(page: page)).url
        retrieveModel(from: url,
                      completionHandler: { [weak self] result in
                        if ((try? result.get()) != nil) {
                            self?.page += 1
                        }
                        self?.isLoading = false
                        completionHandler(result)
                      })
    }
}
