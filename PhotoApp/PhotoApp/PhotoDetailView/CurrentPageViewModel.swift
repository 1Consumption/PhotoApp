//
//  CurrentPageViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/11.
//

import Foundation

struct CurrentPageViewModelInput {
    let page: Observable<Int> = Observable<Int>()
}

struct CurrentPageViewModelOutput {
    let index: Observable<Int> = Observable<Int>()
}

final class CurrentPageViewModel: ViewModelType {
    private let page: Observable<Int> = Observable<Int>()
    private(set) var bag: CancellableBag = CancellableBag()
    
    func transform(input: CurrentPageViewModelInput) -> CurrentPageViewModelOutput {
        let output = CurrentPageViewModelOutput()
        
        input.page.bind {
            output.index.value = $0
        }.store(in: &bag)
        
        return output
    }
}
