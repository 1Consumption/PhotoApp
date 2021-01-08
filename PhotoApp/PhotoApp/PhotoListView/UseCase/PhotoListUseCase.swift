//
//  PhotoListUseCase.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

final class PhotoListUseCase {
    private(set) var page: Int = 1
    private let networkManager: NetworkManageable
    
    init(networkManageable: NetworkManager) {
        self.networkManager = networkManageable
    }
    
    func retrievePhotoList(failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping ([Photo]) -> Void) {
        let url = EndPoint(queryItems: .photoList(page: page)).url
        
        networkManager.requestData(from: url,
                                   method: .get,
                                   header: ["Authorization": Secret.APIKey],
                                   completionHandler: {
                                    switch $0 {
                                    case .success(let data):
                                        do {
                                            let photoList = try JSONDecoder().decode([Photo].self, from: data)
                                            self.page += 1
                                            successHandler(photoList)
                                        } catch {
                                            failureHandler(.decodeError(description: error.localizedDescription))
                                        }
                                    case .failure(let networError):
                                        failureHandler(.networkError(description: networError.description))
                                    }
                                   })
    }
}
