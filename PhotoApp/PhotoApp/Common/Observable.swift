//
//  Observable.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import Foundation

final class Observable<T> {
    typealias Handler = ((T?) -> Void)

    private var handler: Handler?
    var value: T? {
        didSet {
            handler?(value)
        }
    }
    
    func bind(_ handler: Handler?) {
        self.handler = handler
    }
}
