//
//  PhotoListViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

final class PhotoListViewModel {
    private let photoListUseCase: PhotoListUseCase
    private var handler: ((Range<Int>) -> Void)?
    private var photoList: [Photo] {
        didSet {
            let stardIndex = oldValue.count
            let endIndex = photoList.count
            handler?(stardIndex..<endIndex)
        }
    }
    
    init(networkManageable: NetworkManageable = NetworkManager()) {
        photoList = [Photo]()
        photoListUseCase = PhotoListUseCase(networkManageable: networkManageable)
    }
    
    func retrievePhotoList(failureHandler: @escaping (UseCaseError) -> Void) {
        photoListUseCase.retrievePhotoList(failureHandler: failureHandler,
                                           successHandler: { [weak self] in
                                            self?.photoList.append(contentsOf: $0)
                                           })
    }
    
    func bind(_ handler: @escaping ((Range<Int>) -> Void)) {
        self.handler = handler
    }
}
