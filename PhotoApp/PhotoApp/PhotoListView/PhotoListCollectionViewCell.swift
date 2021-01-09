//
//  PhotoListCollectionViewCell.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

final class PhotoListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "PhotoListCollectionViewCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        authorNameLabel.text = nil
    }
}
