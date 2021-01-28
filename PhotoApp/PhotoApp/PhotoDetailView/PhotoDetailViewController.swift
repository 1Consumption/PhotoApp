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
    
    private var bag: CancellableBag = CancellableBag()
    private var isLayouted: Bool = false
    private let dataSource: PhotoDetailCollectionViewDataSource = PhotoDetailCollectionViewDataSource()
    private let currentPageViewModel: CurrentPageViewModel = CurrentPageViewModel()
    private let currentPageViewModelInput: CurrentPageViewModelInput = CurrentPageViewModelInput()
    
    var photoListViewModelInput: SendEventType?
    var photoListViewModelOutput: DeliverInsertedIndexPathType?
    var photoList: PhotoList?
    var currentIndexPath: IndexPath?
    weak var delegate: PhotoDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setPhotoDetailCollectionView()
        bindPhotoViewModel()
        bindCurrentPageViewModel()
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barStyle = .black
        
        let button = UIBarButtonItem(image: UIImage(named: "close"),
                                     style: .done,
                                     target: navigationController,
                                     action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = button

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setPhotoDetailCollectionView() {
        dataSource.photoList = photoList
        photoDetailCollectionView.dataSource = dataSource
        photoDetailCollectionView.delegate = self
    }
    
    private func scrollPhotoDetailCollectionView() {
        guard !isLayouted else { return }
        isLayouted = true
        guard let indexPath = currentIndexPath else { return }
        photoDetailCollectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: false)
    }
    
    private func bindPhotoViewModel() {
        photoListViewModelOutput?.errorOccurred.bind { error in
            guard let error = error else { return }
            DispatchQueue.main.async {
                UIAlertController.showUseCaseErrorAlert(error, presentor: self)
            }
        }.store(in: &bag)
        
        photoListViewModelOutput?.changedIndexPath.bind { range in
            guard let range = range else { return }
            DispatchQueue.main.async { [weak self] in
                self?.photoDetailCollectionView.insertItems(at: range)
            }
        }.store(in: &bag)
    }
    
    private func bindCurrentPageViewModel() {
        let output = currentPageViewModel.transform(input: currentPageViewModelInput)
        
        output.index.bind { index in
            guard let index = index else { return }
            DispatchQueue.main.async { [weak self] in
                self?.navigationItem.title = self?.photoList?.photo(of: index)?.user.name
            }
        }.store(in: &bag)
    }
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndex = collectionView.numberOfItems(inSection: 0)
        
        guard lastIndex == indexPath.item + 1 else { return }
        
        photoListViewModelInput?.sendEvent.fire()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentX = scrollView.contentOffset.x
        
        let width = view.frame.width
        let page = Int(round(currentX / width))
        
        currentPageViewModelInput.page.value = page
    }
}
