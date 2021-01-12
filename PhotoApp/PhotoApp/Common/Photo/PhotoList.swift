//
//  PhotoList.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import Foundation

final class PhotoList {
    private var list: [Photo] = [Photo]()
    
    var count: Int {
        return list.count
    }
    
    func append(contentsOf photoList: [Photo]) {
        list.append(contentsOf: photoList)
    }
    
    func append(_ element: Photo) {
        list.append(element)
    }
    
    func photo(of index: Int) -> Photo? {
        guard (0..<list.count) ~= index else { return nil }
        return list[index]
    }
}
