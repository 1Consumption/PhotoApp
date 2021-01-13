//
//  SearchPhotoUseCase.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/12.
//

import Foundation

final class SearchPhotoUseCase: RemoteDataDecodableType {
    private(set) var page: Int = 1
    let networkManager: NetworkManageable
    
    init(networkManageable: NetworkManageable) {
        self.networkManager = networkManageable
    }
    
    func retrievePhotoList(with query: String, failureHandler: @escaping (UseCaseError) -> Void, successHandler: @escaping (PhotoSearchResult) -> Void) {
        let url = EndPoint(urlInfomation: .search(query: query, page: page)).url
        retrieveModel(from: url,
                      failureHandler: failureHandler,
                      modelWillDeliverHandler: { [weak self] in self?.page += 1 },
                      successHandler: successHandler)
    }
    
    func resetPage() {
        page = 1
    }
}
