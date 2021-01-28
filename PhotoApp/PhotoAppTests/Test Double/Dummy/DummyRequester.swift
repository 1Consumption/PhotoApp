//
//  DummyRequester.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/28.
//

@testable import PhotoApp
import Foundation

final class DummyRequester: Requestable {
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession().dataTask(with: URL(string: "")!)
    }
}
