//
//  SendEventType+DeliverInsertedIndexPathType.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/13.
//

import Foundation

protocol SendEventType {
    var sendEvent: Observable<Void> { get }
}

protocol DeliverInsertedIndexPathType {
    var errorOccurred: Observable<UseCaseError> { get }
    var changedIndexPath: Observable<[IndexPath]> { get }
}
