//
//  PhotoViewModel.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import class UIKit.UIImage
import Foundation

struct PhotoViewModelInput {
    let sendEvent: Observable<Void> = Observable<Void>()
}

struct PhotoViewModelOutput {
    let receivedImage: Observable<UIImage> = Observable<UIImage>()
}

final class PhotoViewModel: ViewModelType {
    let photo: Photo
    private let imageManager: ImageRetrievable
    private(set) var bag: CancellableBag = CancellableBag()
    
    init(photo: Photo, imageRetrievable: ImageRetrievable = ImageManager.shared) {
        self.photo = photo
        self.imageManager = imageRetrievable
    }
    
    func transform(input: PhotoViewModelInput) -> PhotoViewModelOutput {
        let output = PhotoViewModelOutput()
        
        input.sendEvent.bind { [weak self] _ in
            guard let url = self?.photo.urls.regular else { return }
            guard var bag = self?.bag else { return }
            self?.imageManager.retrieveImage(from: url) { result in
                switch result {
                case .success(let image):
                    output.receivedImage.value = image
                case .failure:
                    break
                }
            }?.store(in: &bag)
            
            self?.bag = bag
        }.store(in: &bag)
        
        return output
    }
}
