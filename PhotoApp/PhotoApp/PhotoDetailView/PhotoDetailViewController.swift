//
//  PhotoDetailViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/10.
//

import UIKit

protocol PhotoDetailViewControllerDelegate: class {
    func scrollToItem(at indexPath: IndexPath?)
}

final class PhotoDetailViewController: UIViewController {
    static let identifier: String = "PhotoDetailViewController"
    
    @IBOutlet weak var photoDetailCollectionView: UICollectionView!
    
    private var isLayouted: Bool = false
    var dataSource: PhotoCollectionViewDataSource?
    var currentIndexPath: IndexPath?
    weak var delegate: PhotoDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhotoDetailCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollPhotoDetailCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentIndexPath = photoDetailCollectionView.indexPathsForVisibleItems.first
        delegate?.scrollToItem(at: currentIndexPath)
    }
    
    private func setPhotoDetailCollectionView() {
        photoDetailCollectionView.register(UINib(nibName: "PhotoCell", bundle: .main),
                                           forCellWithReuseIdentifier: PhotoCell.identifier)
        photoDetailCollectionView.dataSource = dataSource
        photoDetailCollectionView.delegate = self
    }
    
    private func scrollPhotoDetailCollectionView() {
        guard !isLayouted else { return }
        isLayouted = true
        guard let indexPath = currentIndexPath else { return }
        photoDetailCollectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: false)
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
