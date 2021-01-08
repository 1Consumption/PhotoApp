//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

final class PhotoListViewController: UIViewController {
    @IBOutlet weak var photoListCollectionView: UICollectionView!

    private let dataSource: PhotoListCollectionViewDataSource = PhotoListCollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoListCollectionView.dataSource = dataSource
        photoListCollectionView.delegate = self
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let size = dataSource.photo(of: indexPath.item) else { return .zero }
        let width = CGFloat(size.width)
        let height = CGFloat(size.height)
        return CGSize(width: view.frame.width, height: height * view.frame.width / width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndexPathItem = collectionView.numberOfItems(inSection: 0)
        
        guard lastIndexPathItem == indexPath.item + 1 else { return }
        
        // Todo: 다음 페이지에 해당하는 모델 받아오기
    }
}
