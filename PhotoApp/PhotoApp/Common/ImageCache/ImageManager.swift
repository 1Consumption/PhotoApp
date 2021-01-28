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
    
    func retrieveImage(from url: String, completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void) -> Cancellable? {
        if let image = memoryCacheStorage.object(for: url) {
            imageManageQueue.async {
                completionHandler(.success(image))
            }
        } else {
            let urls = URL(string: url)
            let dataTask = networkManageable.requestData(from: urls,
                                                         method: .get,
                                                         header: nil,
                                                         completionHandler: { [weak self] result in
                                                            switch result {
                                                            case .failure(let error):
                                                                completionHandler(.failure(error))
                                                            case .success(let data):
                                                                self?.imageManageQueue.async {
                                                                    let image = UIImage(data: data)
                                                                    completionHandler(.success(image))
                                                                    self?.memoryCacheStorage.insert(image, for: url)
                                                                }
                                                            }
                                                         })
            return Cancellable {
                dataTask?.cancel()
            }
        }
        return nil
    }
}

protocol ImageRetrievable {
    func retrieveImage(from url: String, completionHandler: @escaping (Result<UIImage?, NetworkError>) -> Void) -> Cancellable?
}
