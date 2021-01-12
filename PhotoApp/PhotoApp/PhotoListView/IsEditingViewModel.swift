//
//  IsEditingViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/12.
//

import Foundation

final class IsEditingViewModel {
    private var isEditing: Observable<Bool> = Observable<Bool>()
    private var bag: CancellableBag = CancellableBag()
    
    func send(state isEditing: Bool) {
        self.isEditing.value = isEditing
    }
    
    func bind(_ handler: @escaping (Bool?) -> Void) {
        isEditing.bind(handler)
            .store(in: &bag)
    }
}
