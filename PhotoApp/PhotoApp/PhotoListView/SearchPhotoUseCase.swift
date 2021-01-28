//
//  SearchPhotoUseCase.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/12.
//

import Foundation

final class SearchPhotoUseCase: RemoteDataDecodableType {
    typealias T = PhotoSearchResult
    private(set) var page: Int = 1
    let networkManager: NetworkManageable
    private var prevQuery: String?
    private var isLoading: Bool = false
    
    init(networkManageable: NetworkManageable) {
        self.networkManager = networkManageable
    }
    
    func retrievePhotoList(with query: String?, completionHandler: @escaping (Result<PhotoSearchResult, UseCaseError>) -> Void) {
        guard !isLoading else {
            completionHandler(.failure(.duplicatedRequest))
            return
        }
        
        isLoading = true
        
        var queryString = ""
        
        if let query = query {
            queryString = query
            prevQuery = query
        } else {
            guard let prevQuery = prevQuery else {
                completionHandler(.failure(.networkError(networkError: .invalidURL)))
                isLoading = false
                return
            }
            queryString = prevQuery
        }
        
        let url = EndPoint(urlInfomation: .search(query: queryString, page: page)).url
        retrieveModel(from: url, completionHandler: { [weak self] result in
            if ((try? result.get()) != nil) {
                self?.page += 1
            }
            self?.isLoading = false
            completionHandler(result)
        })
    }
    
    func resetPage() {
        page = 1
    }
}
