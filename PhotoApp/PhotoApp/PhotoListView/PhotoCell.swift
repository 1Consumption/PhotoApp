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
    private var bag: CancellableBag = CancellableBag()
    private var viewModelInput: PhotoViewModelInput = PhotoViewModelInput()
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    
    func bind(_ photoViewModel: PhotoViewModel) {
        viewModel = photoViewModel
        userNameLabel.text = viewModel?.photo.user.name
        
        let output = viewModel?.transform(input: viewModelInput)
        output?.receivedImage.bind { image in
            DispatchQueue.main.async { [weak self] in
                self?.acitivityIndicator.stopAnimating()
                self?.photoImageView.image = image
            }
        }.store(in: &bag)
        
        viewModelInput.sendEvent.fire()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModelInput = PhotoViewModelInput()
        bag.removeAll()
        photoImageView.image = nil
        userNameLabel.text = nil
        acitivityIndicator.startAnimating()
    }
}
