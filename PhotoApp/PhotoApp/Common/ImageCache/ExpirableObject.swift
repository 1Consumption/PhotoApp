//
//  ExpirableObject.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

final class ExpirableObject<T> {    
    let value: T
    private var expectedExpireDate: Date
    var isExpired: Bool {
        return Date() > expectedExpireDate
    }
    
    init(with value: T, expireTime: ExpireTime) {
        self.value = value
        expectedExpireDate = Date(timeIntervalSinceNow: expireTime.timeInterval)
    }
}
