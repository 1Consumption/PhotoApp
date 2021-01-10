//
//  PhotoListViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

final class PhotoListViewModel {
    private let photoListUseCase: PhotoListUseCase
    private var range: Observable<[IndexPath]> = Observable<[IndexPath]>()
    private var photoList: PhotoList
    
    var count: Int {
        return photoList.count
    }
    
    init(networkManageable: NetworkManageable = NetworkManager()) {
        photoList = PhotoList()
        photoListUseCase = PhotoListUseCase(networkManageable: networkManageable)
    }
    
    func retrievePhotoList(failureHandler: @escaping (UseCaseError) -> Void) {
        photoListUseCase.retrievePhotoList(failureHandler: failureHandler,
                                           successHandler: { [weak self] in
                                            guard let self = self else { return }
                                            let startIndex = self.photoList.count
                                            let endIndex = startIndex + $0.count
                                            self.photoList.append(contentsOf: $0)
                                            self.range.value = (startIndex..<endIndex).map {
                                                IndexPath(item: $0, section: 0)
                                            }
                                           })
    }
    
    func bind(_ handler: @escaping (([IndexPath]?) -> Void)) {
        range.bind(handler)
    }
    
    func photo(of index: Int) -> Photo? {
        photoList.photo(of: index)
    }
}
