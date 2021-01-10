//
//  PhotoViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import class UIKit.UIImage

final class PhotoViewModel {
    let photo: Photo
    private var image: Observable<UIImage> = Observable<UIImage>()
    private let imageManager: ImageRetrievable
    
    init(photo: Photo, imageRetrievable: ImageRetrievable = ImageManager()) {
        self.photo = photo
        self.imageManager = imageRetrievable
    }
    
    func retrieveImage() {
        let url = photo.urls.regular
        imageManager.retrieveImage(from: url, failureHandler: nil, imageHandler: { [weak self] in
            self?.image.value = $0
        })
    }
    
    func bind(_ handler: @escaping ((UIImage?) -> Void)) {
        image.bind(handler)
    }
}
