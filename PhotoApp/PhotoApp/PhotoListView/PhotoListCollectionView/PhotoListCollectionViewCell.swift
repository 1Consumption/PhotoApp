//
//  PhotoListCollectionViewCell.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

final class PhotoListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "PhotoListCollectionViewCell"
    private var viewModel: PhotoViewModel?

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        authorNameLabel.text = viewModel?.photo.user.name
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
        authorNameLabel.text = nil
    }
}
