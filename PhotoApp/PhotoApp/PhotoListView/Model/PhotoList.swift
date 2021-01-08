//
//  PhotoList.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import Foundation

struct PhotoList {
    var list: [Photo]
    var count: Int {
        return list.count
    }
    
    init() {
        list = [Photo]()
    }
    
    mutating func append(contentsOf photoList: [Photo]) {
        list.append(contentsOf: photoList)
    }
    
    mutating func append(_ element: Photo) {
        list.append(element)
    }
    
    func photo(of index: Int) -> Photo? {
        guard index < list.count else { return nil }
        return list[index]
    }
}
