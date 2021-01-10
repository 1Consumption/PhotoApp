//
//  Cancellable.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/10.
//

import Foundation

typealias CancellableBag = Set<Cancellable>

final class Cancellable {
    private let cancelHandler: () -> Void
    
    init(_ cancelHandler: @escaping () -> Void) {
        self.cancelHandler = cancelHandler
    }
    
    deinit {
        cancelHandler()
    }
    
    func store(in bag: inout CancellableBag) {
        bag.insert(self)
    }
    
    func cancel() {
        cancelHandler()
    }
}

extension Cancellable: Hashable {
    static func == (lhs: Cancellable, rhs: Cancellable) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
