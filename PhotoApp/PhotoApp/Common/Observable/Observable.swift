//
//  Observable.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import Foundation

final class Observable<T> {
    typealias Handler = (T?) -> Void

    private var observers: [UUID: Handler?] = [:]
    
    var value: T? {
        didSet {
            observers.values.forEach {
                $0?(value)
            }
        }
    }
    
    func bind(_ handler: Handler?) -> Cancellable {
        let id = UUID()
        observers[id] = handler
        
        let cancelable = Cancellable { [weak self] in
            self?.observers[id] = nil
        }
        
        return cancelable
    }
    
    func fire() where T == Void {
        observers.values.forEach {
            $0?(value)
        }
    }
}
