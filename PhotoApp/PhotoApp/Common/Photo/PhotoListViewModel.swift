//
//  PhotoListViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

struct PhotoListViewModelInput: SendEventType {
    let sendEvent: Observable<Void> = Observable<Void>()
}

struct PhotoListViewModelOutput: DeliverInsertedIndexPathType {
    let errorOccurred: Observable<UseCaseError> = Observable<UseCaseError>()
    let changedIndexPath: Observable<[IndexPath]> = Observable<[IndexPath]>()
}

final class PhotoListViewModel {
    private let photoListUseCase: PhotoListUseCase
    
    private var bag: CancellableBag = CancellableBag()
    var photoList: PhotoList = PhotoList()
    
    init(networkManageable: NetworkManageable = NetworkManager()) {
        photoListUseCase = PhotoListUseCase(networkManageable: networkManageable)
    }
    
    func transfrom(_ input: PhotoListViewModelInput?) -> PhotoListViewModelOutput {
        let output = PhotoListViewModelOutput()
        input?.sendEvent.bind { [weak self] _ in
            self?.photoListUseCase.retrievePhotoList(failureHandler: {
                output.errorOccurred.value = $0
            },
            successHandler: { [weak self] in
                guard let count = self?.photoList.count else { return }
                let startIndex = count
                let endIndex = startIndex + $0.count
                self?.photoList.append(contentsOf: $0)
                output.changedIndexPath.value = (startIndex..<endIndex).map {
                    IndexPath(item: $0, section: 0)
                }
            })
        }.store(in: &bag)
        
        return output
    }
    
    func photo(of index: Int) -> Photo? {
        photoList.photo(of: index)
    }
}
