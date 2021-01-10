//
//  PhotoDetailViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/10.
//

import UIKit

final class PhotoDetailViewController: UIViewController {
    static let identifier: String = "PhotoDetailViewController"
    
    @IBOutlet weak var photoDetailCollectionView: UICollectionView!
    
    var dataSource: PhotoCollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoDetailCollectionView.register(UINib(nibName: "PhotoCell", bundle: .main),
                                           forCellWithReuseIdentifier: PhotoCell.identifier)
        photoDetailCollectionView.dataSource = dataSource
        photoDetailCollectionView.delegate = self
    }
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource?.photo(of: indexPath.item) else { return .zero }
        
        let width = CGFloat(photo.width)
        let height = CGFloat(photo.height)
        
        return CGSize(width: view.frame.width, height: height * view.frame.width / width)
    }
}
