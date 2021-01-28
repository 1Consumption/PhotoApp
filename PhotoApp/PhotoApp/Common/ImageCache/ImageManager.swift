//
//  ImageManager.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

final class ImageManager: ImageRetrievable {
    static let shared: ImageManager = ImageManager()
    
    private let networkManageable: NetworkManageable
    private let imageManageQueue: DispatchQueue = DispatchQueue(label: "com.imageManager", attributes: .concurrent)
    private let memoryCacheStorage: MemoryCacheStorage<UIImage> = MemoryCacheStorage<UIImage>(expireTime: .minute(1))
    
    init(networkManageable: NetworkManageable = NetworkManager(requester: ImageRequster())) {
        self.networkManageable = networkManageable
    }
    
    func retrieveImage(from url: String, dataTaskHandler: @escaping ((URLSessionDataTask?) -> Void),  failureHandler: ((NetworkError) -> Void)? = nil, imageHandler: @escaping (UIImage?) -> Void) {
        imageManageQueue.async { [weak self] in
            if let image = self?.memoryCacheStorage.object(for: url) {
                imageHandler(image)
                dataTaskHandler(nil)
            } else {
                let urls = URL(string: url)
                let dataTask = self?.networkManageable.requestData(from: urls,
                                                                   method: .get,
                                                                   header: nil,
                                                                   completionHandler: { result in
                                                                    switch result {
                                                                    case .failure(let error):
                                                                        failureHandler?(error)
                                                                    case .success(let data):
                                                                        let image = UIImage(data: data)
                                                                        imageHandler(image)
                                                                        self?.memoryCacheStorage.insert(image, for: url)
                                                                    }
                                                                   })
                dataTaskHandler(dataTask)
            }
        }
    }
}

protocol ImageRetrievable {
    func retrieveImage(from url: String, dataTaskHandler: @escaping ((URLSessionDataTask?) -> Void), failureHandler: ((NetworkError) -> Void)?, imageHandler: @escaping (UIImage?) -> Void)
}
