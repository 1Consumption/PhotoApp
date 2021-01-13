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
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        viewModel?.bind { image in
            DispatchQueue.main.async { [weak self] in
                self?.photoImageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }
        viewModel?.retrieveImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        activityIndicator.startAnimating()
    }
}
