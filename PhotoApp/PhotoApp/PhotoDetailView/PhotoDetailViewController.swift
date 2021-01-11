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
    private let dataSource: PhotoDetailCollectionViewDataSource = PhotoDetailCollectionViewDataSource()
    var photoListViewModel: PhotoListViewModel?
    var currentIndexPath: IndexPath?
    weak var delegate: PhotoDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setNavigationItemTitle(with: currentIndexPath)
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
    
    private func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        
        let button = UIBarButtonItem(image: UIImage(named: "close"),
                                     style: .done,
                                     target: navigationController,
                                     action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = button

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setNavigationItemTitle(with indexPath: IndexPath?) {
        guard let index = indexPath?.item else { return }
        navigationItem.title = photoListViewModel?.photo(of: index)?.user.name
    }
    
    private func setPhotoDetailCollectionView() {
        dataSource.photoListViewModel = photoListViewModel
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
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setNavigationItemTitle(with: indexPath)
    }
}
