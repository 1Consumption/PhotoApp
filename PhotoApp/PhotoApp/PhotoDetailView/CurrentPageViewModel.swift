//
//  CurrentPageViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/11.
//

import Foundation

final class CurrentPageViewModel {
    private let page: Observable<Int> = Observable<Int>()
    private var bag: CancellableBag = CancellableBag()
    
    func send(_ index: Int) {
        guard index != page.value else { return }
        page.value = index
    }
    
    func bind(_ handler: @escaping (Int?) -> Void) {
        page.bind(handler)
            .store(in: &bag)
    }
}
