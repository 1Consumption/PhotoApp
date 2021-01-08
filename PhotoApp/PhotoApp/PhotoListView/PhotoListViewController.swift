//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

final class PhotoListViewController: UIViewController {
    private var model: [Photo] = dummyPhotos
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoListCollectionView.dataSource = self
        photoListCollectionView.delegate = self
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.identifier, for: indexPath) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        let url = URL(string: model[indexPath.item].urls.regular)!
        let data = try! Data(contentsOf: url)
        cell.photoImageView.image = UIImage(data: data)
        cell.authorNameLabel.text = "\(model[indexPath.item].user.name)"
        return cell
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(model[indexPath.item].width)
        let height = CGFloat(model[indexPath.item].height)
        return CGSize(width: view.frame.width, height: height * view.frame.width / width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndexPathItem = collectionView.numberOfItems(inSection: 0)
        
        guard lastIndexPathItem == indexPath.item + 1 else { return }
        
        // Todo: 다음 페이지에 해당하는 모델 받아오기
    }
}
