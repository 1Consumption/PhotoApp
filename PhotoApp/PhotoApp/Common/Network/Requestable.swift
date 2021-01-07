//
//  Requestable.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import Foundation

protocol Requestable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
