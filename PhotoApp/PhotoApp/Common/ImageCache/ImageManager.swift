//
//  ImageManager.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

final class ImageManager {
    static let shared: ImageManager = ImageManager()
    
    private let networkManageable: NetworkManageable
    private let imageManageQueue: DispatchQueue = DispatchQueue(label: "com.imageManager", attributes: .concurrent)
    private let memoryCacheStorage: MemoryCacheStorage<UIImage> = MemoryCacheStorage<UIImage>(expireTime: .minute(1))
    
    init(networkManageable: NetworkManageable = NetworkManager()) {
        self.networkManageable = networkManageable
    }
    
    func retrieveImage(from url: String, failureHandler: ((NetworkError) -> Void)? = nil, imageHandler: @escaping (UIImage?) -> Void) {
        imageManageQueue.async { [weak self] in
            if let image = self?.memoryCacheStorage.object(for: url) {
                imageHandler(image)
            } else {
                let urls = URL(string: url)
                self?.networkManageable.requestData(from: urls,
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
            }
        }
    }
}
