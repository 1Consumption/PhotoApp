//
//  MemoryCacheStorage.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

final class MemoryCacheStorage<T> {
    private let cache: NSCache<NSString, ExpirableObject<T?>> = NSCache<NSString, ExpirableObject<T?>>()
    private let lock: NSLock = NSLock()
    private let expireTime: ExpireTime
    private var keys: Set<String> = Set<String>()
    
    init(size: Int = 0, expireTime: ExpireTime) {
        cache.totalCostLimit = size
        self.expireTime = expireTime
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cleanUpExpired),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }
    
    func insert(_ obejct: T?, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        
        cache.setObject(ExpirableObject(with: obejct, expireTime: expireTime), forKey: key as NSString)
        keys.insert(key)
    }
    
    func object(for key: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        guard let cached = cache.object(forKey: key as NSString) else { return nil }
        guard !cached.isExpired else {
            removeObject(for: key)
            return nil
        }
        
        cached.resetExpectedExpireDate(expireTime)
        return cached.value
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
    
    @objc private func cleanUpExpired() {
        removeExpiredObjects()
    }
}
