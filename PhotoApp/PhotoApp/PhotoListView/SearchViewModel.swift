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
}

struct SearchViewModelOutput {
    let textFieldEditBegan: Observable<Bool> = Observable<Bool>()
    let cancelButtonPushed: Observable<Bool> = Observable<Bool>()
}

final class SearchViewModel {
    private var bag: CancellableBag = CancellableBag()
    
    func transform(input: SearchViewModelInput) -> SearchViewModelOutput {
        let output = SearchViewModelOutput()
        
        input.textFieldEditBegan.bind { _ in
            output.textFieldEditBegan.value = false
        }.store(in: &bag)
        
        input.cancelButtonPushed.bind { _ in
            output.cancelButtonPushed.value = true
        }.store(in: &bag)
        
        return output
    }
}
