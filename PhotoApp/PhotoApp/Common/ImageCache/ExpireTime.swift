//
//  ExpireTime.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import Foundation

enum ExpireTime {
    case second(TimeInterval)
    case minute(Double)
    
    var timeInterval: TimeInterval {
        switch self {
        case .second(let time):
            return time
        case .minute(let time):
            return time * 60
        }
    }
}
