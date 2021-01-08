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
    private let photoListViewModel: PhotoListViewModel = PhotoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.photoListViewModel = photoListViewModel
        photoListCollectionView.dataSource = dataSource
        photoListCollectionView.delegate = self
        
        photoListViewModel.bind({ range in
            DispatchQueue.main.async { [weak self] in
                self?.photoListCollectionView.performBatchUpdates({
                    self?.photoListCollectionView.insertItems(at: range.map { IndexPath(item: $0, section: 0)})
                })
            }
        })
        
        photoListViewModel.retrievePhotoList(failureHandler: { [weak self] in
                                                self?.showErrorAlert(with: $0.message)})
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController().confirmAlert(title: "에러 발생", message: message)
        present(alert, animated: true, completion: nil)
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
        
        photoListViewModel.retrievePhotoList(failureHandler: { [weak self] in
                                                self?.showErrorAlert(with: $0.message)})
    }
}
