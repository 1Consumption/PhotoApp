//
//  SearchViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/12.
//

import Foundation

struct SearchViewModelInput: SendEventType {
    let textFieldEditBegan: Observable<Void> = Observable<Void>()
    let cancelButtonPushed: Observable<Void> = Observable<Void>()
    let sendQuery: Observable<String> = Observable<String>()
    let sendEvent: Observable<Void> = Observable<Void>()
}

struct SearchViewModelOutput: DeliverInsertedIndexPathType {
    let textFieldEditBegan: Observable<Bool> = Observable<Bool>()
    let cancelButtonPushed: Observable<Bool> = Observable<Bool>()
    let errorOccurred: Observable<UseCaseError> = Observable<UseCaseError>()
    let isResultsExist: Observable<Bool> = Observable<Bool>()
    let changedIndexPath: Observable<[IndexPath]> = Observable<[IndexPath]>()
}

final class SearchViewModel: ViewModelType {
    private let searchPhotoUseCase: SearchPhotoUseCase
    private(set) var bag: CancellableBag = CancellableBag()
    var photoList: PhotoList = PhotoList()
    
    init(networkManageable: NetworkManageable = NetworkManager()) {
        searchPhotoUseCase = SearchPhotoUseCase(networkManageable: networkManageable)
    }
    
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {
        let output = SearchViewModelOutput()
        
        input.textFieldEditBegan.bind { [weak self] _ in
            self?.searchPhotoUseCase.resetPage()
            output.textFieldEditBegan.value = false
        }.store(in: &bag)
        
        input.cancelButtonPushed.bind { _ in
            output.cancelButtonPushed.value = true
        }.store(in: &bag)
        
        input.sendQuery.bind { [weak self] in
            guard let query = $0 else { return }
            self?.searchPhotoUseCase.retrievePhotoList(with: query) { result in
                switch result {
                case .success(let model):
                    let model = model.results
                    self?.photoList.reset()
                    self?.photoList.append(contentsOf: model)
                    output.isResultsExist.value = !model.isEmpty
                case .failure(let error):
                    output.errorOccurred.value = error
                    output.isResultsExist.value = false
                }
            }
        }.store(in: &bag)
        
        input.sendEvent.bind { [weak self] _ in
            self?.searchPhotoUseCase.retrievePhotoList(with: nil) { [weak self] result in
                switch result {
                case .success(let model):
                    let model = model.results
                    
                    guard !model.isEmpty else { return }
                    
                    guard let count = self?.photoList.count else { return }
                    
                    let startIndex = count
                    let endIndex = startIndex + model.count
                    self?.photoList.append(contentsOf: model)
                    output.changedIndexPath.value = (startIndex..<endIndex).map {
                        IndexPath(item: $0, section: 0)
                    }
                case .failure(let error):
                    output.errorOccurred.value = error
                }
            }
        }.store(in: &bag)
        
        return output
    }
}
