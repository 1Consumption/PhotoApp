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
    private var prevQuery: String?
    
    init(networkManageable: NetworkManageable) {
        self.networkManager = networkManageable
    }
    
    func retrievePhotoList(with query: String?, completionHandler: @escaping (Result<PhotoSearchResult, UseCaseError>) -> Void) {
        var queryString = ""
        
        if let query = query {
            queryString = query
            prevQuery = query
        } else {
            guard let prevQuery = prevQuery else {
                completionHandler(.failure(.networkError(networkError: .invalidURL)))
                return
            }
            queryString = prevQuery
        }
        
        let url = EndPoint(urlInfomation: .search(query: queryString, page: page)).url
        retrieveModel(from: url, modelWillDeliverHandler: { [weak self] in self?.page += 1 }, completionHandler: completionHandler)
    }
    
    func resetPage() {
        page = 1
    }
}
