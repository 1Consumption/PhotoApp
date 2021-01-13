//
//  PhotoCell.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/13.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    static let identifier: String = "PhotoCell"
    private var viewModel: PhotoViewModel?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        userNameLabel.text = viewModel?.photo.user.name
        viewModel?.bind { image in
            DispatchQueue.main.async { [weak self] in
                self?.acitivityIndicator.stopAnimating()
                self?.photoImageView.image = image
            }
        }
        viewModel?.retrieveImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        userNameLabel.text = nil
        acitivityIndicator.startAnimating()
    }
}
