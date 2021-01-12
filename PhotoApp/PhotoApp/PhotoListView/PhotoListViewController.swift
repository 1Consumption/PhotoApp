//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

final class PhotoListViewController: UIViewController {
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    // search
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchCancelButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var noResultView: UIView!
    @IBAction func searchCancelTouchedUp(_ sender: Any) {
        searchViewModelInput.cancelButtonPushed.fire()
    }
    
    private let dataSource: PhotoCollectionViewDataSource = PhotoCollectionViewDataSource()
    private let photoListViewModel: PhotoListViewModel = PhotoListViewModel()
    private let searchViewModel: SearchViewModel = SearchViewModel()
    private let searchViewModelInput: SearchViewModelInput = SearchViewModelInput()
    private var bag: CancellableBag = CancellableBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhotoListCollectionVeiw()
        setSearchView()
        sendNeedMoreModelEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setPhotoListCollectionVeiw() {
        dataSource.photoListViewModel = photoListViewModel
        photoListCollectionView.contentInset = UIEdgeInsets(top: 96, left: 0, bottom: 0, right: 0)
        photoListCollectionView.dataSource = dataSource
        photoListCollectionView.delegate = self
        photoListViewModel.bind({ range in
            DispatchQueue.main.async { [weak self] in
                guard let range = range else { return }
                self?.photoListCollectionView.insertItems(at: range)
            }
        })
    }
    
    private func sendNeedMoreModelEvent() {
        photoListViewModel.retrievePhotoList(failureHandler: UIAlertController().showUseCaseErrorAlert(_:))
    }
    
    private func setSearchView() {
        searchContainer.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        searchBar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        searchBar.delegate = self
        bindSearchView()
    }
    
    private func bindSearchView() {
        let output = searchViewModel.transform(input: searchViewModelInput)
        
        output.textFieldEditBegan.bind { [weak self] in
            guard let hiddenFactor = $0 else { return }
            self?.animate { [weak self] in
                self?.searchCancelButton.isHidden = hiddenFactor
            }
        }.store(in: &bag)
        
        output.cancelButtonPushed.bind { [weak self] in
            guard let hiddenFactor = $0 else { return }
            self?.animate { [weak self] in
                self?.searchCancelButton.isHidden = hiddenFactor
                self?.view.endEditing(hiddenFactor)
                self?.searchBar.text = nil
            }
        }.store(in: &bag)
        
        output.useCaseErrorOccurred.bind {
            guard let error = $0 else { return }
            UIAlertController().showUseCaseErrorAlert(error)
        }.store(in: &bag)
    }
    
    private func animate(_ handler: @escaping () -> Void) {
        UIViewPropertyAnimator
            .runningPropertyAnimator(withDuration: 0.2,
                                     delay: 0,
                                     options: .allowUserInteraction,
                                     animations: handler,
                                     completion: nil)
    }
}

extension PhotoListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchViewModelInput.textFieldEditBegan.fire()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchViewModelInput.sendQuery.value = textField.text
        textField.resignFirstResponder()
        return true
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
        
        sendNeedMoreModelEvent()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photoDetailViewController = storyboard?.instantiateViewController(withIdentifier: PhotoDetailViewController.identifier) as? PhotoDetailViewController else { return }
        
        photoDetailViewController.photoListViewModel = photoListViewModel
        photoDetailViewController.currentIndexPath = indexPath
        photoDetailViewController.delegate = self
        
        navigationController?.pushViewController(photoDetailViewController, animated: true)
    }
}

extension PhotoListViewController: PhotoDetailViewControllerDelegate {
    func scrollToItem(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return  }
        photoListCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: false)
    }
}
