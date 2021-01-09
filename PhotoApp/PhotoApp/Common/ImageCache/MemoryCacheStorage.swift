//
//  MemoryCacheStorage.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import Foundation

final class MemoryCacheStorage<T> {
    private let cache: NSCache<NSString, ExpirableObject<T>> = NSCache<NSString, ExpirableObject<T>>()
    private let lock: NSLock = NSLock()
    private let expireTime: ExpireTime
    private var keys: Set<String> = Set<String>()
    
    init(size: Int, expireTime: ExpireTime) {
        cache.totalCostLimit = size
        self.expireTime = expireTime
    }
    
    func insert(_ obejct: T, for key: String) {
        cache.setObject(ExpirableObject(with: obejct, expireTime: expireTime), forKey: key as NSString)
        keys.insert(key)
    }
    
    func object(for key: String) -> T? {
        cache.object(forKey: key as NSString)?.resetExpectedExpireDate(expireTime)
        return cache.object(forKey: key as NSString)?.value
    }
    
    func removeObject(for key: String) {
        keys.remove(key)
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAllObjects() {
        keys.removeAll()
        cache.removeAllObjects()
    }
    
    func removeExpiredObjects() {
        lock.lock()
        
        keys.forEach {
            if cache.object(forKey: $0 as NSString)?.isExpired == true {
                cache.removeObject(forKey: $0 as NSString)
            }
        }
        
        lock.unlock()
    }
}
