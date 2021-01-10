//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

final class PhotoListViewController: UIViewController {
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    private let dataSource: PhotoCollectionViewDataSource = PhotoCollectionViewDataSource()
    private let photoListViewModel: PhotoListViewModel = PhotoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoListCollectionView.register(UINib(nibName: "PhotoCell", bundle: .main), forCellWithReuseIdentifier: PhotoCell.identifier)
        dataSource.photoListViewModel = photoListViewModel
        photoListCollectionView.dataSource = dataSource
        photoListCollectionView.delegate = self
        
        photoListViewModel.bind({ range in
            DispatchQueue.main.async { [weak self] in
                guard let range = range else { return }
                self?.photoListCollectionView.insertItems(at: range)
            }
        })
        
        photoListViewModel.retrievePhotoList(failureHandler: { [weak self] in
                                                self?.showErrorAlert(with: $0)})
    }
    
    private func showErrorAlert(with error: UseCaseError) {
        switch error {
        case .networkError(networkError: .duplicatedRequest):
            break
        default:
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController().confirmAlert(title: "에러 발생", message: error.message)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let photo = dataSource.photo(of: indexPath.item) else { return .zero }
        
        let width = CGFloat(photo.width)
        let height = CGFloat(photo.height)
        
        return CGSize(width: view.frame.width, height: height * view.frame.width / width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndexPathItem = collectionView.numberOfItems(inSection: 0)
        
        guard lastIndexPathItem < indexPath.item + 3 else { return }
        
        photoListViewModel.retrievePhotoList(failureHandler: { [weak self] in
                                                self?.showErrorAlert(with: $0)})
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photoDetailViewController = storyboard?.instantiateViewController(withIdentifier: PhotoDetailViewController.identifier) as? PhotoDetailViewController else { return }
        
        photoDetailViewController.dataSource = dataSource
        photoDetailViewController.currentIndexPath = indexPath
        
        navigationController?.pushViewController(photoDetailViewController, animated: true)
    }
}
