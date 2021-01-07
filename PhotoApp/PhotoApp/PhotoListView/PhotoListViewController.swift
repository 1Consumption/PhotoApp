//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

struct Photo {
    let name: String
    let author: String
}

final class PhotoListViewController: UIViewController {
    
    private var model: [Photo] = [Photo]()
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        (1..<20).forEach { _ in
            let number = Int.random(in: 1...8)
            model.append(Photo(name: "sample\(number)", author: "Author \(number)"))
        }
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
        cell.photoImageView.image = UIImage(named: model[indexPath.item].name)
        cell.authorNameLabel.text = "\(model[indexPath.item].author)"
        return cell
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let size = UIImage(named: model[indexPath.item].name)?.size else { return .zero }
        return CGSize(width: view.frame.width, height: size.height * view.frame.width / size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndexPathItem = collectionView.numberOfItems(inSection: 0)
        
        guard lastIndexPathItem == indexPath.item + 1 else { return }
        
        // Todo: 다음 페이지에 해당하는 모델 받아오기
    }
}
