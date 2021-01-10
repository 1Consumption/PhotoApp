//
//  PhotoCell.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/10.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    static let identifier: String = "PhotoCell"
    private var viewModel: PhotoViewModel?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        userNameLabel.text = viewModel?.photo.user.name
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
        userNameLabel.text = nil
    }
}
