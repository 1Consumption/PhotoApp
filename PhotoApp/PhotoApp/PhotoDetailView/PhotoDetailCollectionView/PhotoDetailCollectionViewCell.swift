//
//  PhotoDetailCollectionViewCell.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/11.
//

import UIKit

final class PhotoDetailCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "PhotoDetailCollectionViewCell"
    private var viewModel: PhotoViewModel?
    private var bag: CancellableBag = CancellableBag()
    private let viewModelInput: PhotoViewModelInput = PhotoViewModelInput()
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        
        let output = viewModel?.transform(input: viewModelInput)
        
        output?.receivedImage.bind { image in
            DispatchQueue.main.async { [weak self] in
                self?.photoImageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }.store(in: &bag)
        
        viewModelInput.sendEvent.fire()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        activityIndicator.startAnimating()
    }
}
