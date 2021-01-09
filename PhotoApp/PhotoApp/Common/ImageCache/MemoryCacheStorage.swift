//
//  MemoryCacheStorage.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import Foundation

final class MemoryCacheStorage<T> {
    private let cache: NSCache<NSString, ExpirableObject<T>> = NSCache<NSString, ExpirableObject<T>>()
    private let expireTime: ExpireTime
    
    init(size: Int, expireTime: ExpireTime) {
        cache.totalCostLimit = size
        self.expireTime = expireTime
    }
    
    func insert(_ obejct: T, for key: String) {
        cache.setObject(ExpirableObject(with: obejct, expireTime: expireTime), forKey: key as NSString)
    }
    
    func object(for key: String) -> T? {
        return cache.object(forKey: key as NSString)?.value
    }
    
    func removeObject(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
