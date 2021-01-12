//
//  SearchViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/12.
//

import Foundation

struct SearchViewModelInput {
    let textFieldEditBegan: Observable<Void> = Observable<Void>()
    let cancelButtonPushed: Observable<Void> = Observable<Void>()
    let sendQuery: Observable<String> = Observable<String>()
}

struct SearchViewModelOutput {
    let textFieldEditBegan: Observable<Bool> = Observable<Bool>()
    let cancelButtonPushed: Observable<Bool> = Observable<Bool>()
    let useCaseErrorOccurred: Observable<UseCaseError> = Observable<UseCaseError>()
    let isResultsExist: Observable<Bool> = Observable<Bool>()
}

final class SearchViewModel {
    private var bag: CancellableBag = CancellableBag()
    private var photoList: PhotoList
    private let searchPhotoUseCase: SearchPhotoUseCase
    
    init(networkManageable: NetworkManageable = NetworkManager()) {
        photoList = PhotoList()
        searchPhotoUseCase = SearchPhotoUseCase(networkManageable: networkManageable)
    }
    
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {
        let output = SearchViewModelOutput()
        
        input.textFieldEditBegan.bind { _ in
            output.textFieldEditBegan.value = false
        }.store(in: &bag)
        
        input.cancelButtonPushed.bind { _ in
            output.cancelButtonPushed.value = true
        }.store(in: &bag)
        
        input.sendQuery.bind { [weak self] in
            guard let query = $0 else { return }
            self?.searchPhotoUseCase
                .retrievePhotoList(with: query,
                                   failureHandler: {
                                    output.useCaseErrorOccurred.value = $0
                                    output.isResultsExist.value = false
                                   },
                                   successHandler: {
                                    let model = $0.results
                                    output.isResultsExist.value = !model.isEmpty
                                    
                                    guard !model.isEmpty else { return }
                                   })
        }.store(in: &bag)
        
        return output
    }
}
