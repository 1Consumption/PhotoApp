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
    
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        viewModel?.bind { [weak self] image in
            DispatchQueue.main.async {
                self?.photoImageView.image = image
            }
        }
        viewModel?.retrieveImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}
