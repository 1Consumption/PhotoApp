//
//  PhotoListCollectionViewDataSource.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

final class PhotoListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var photoListViewModel: PhotoListViewModel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoListViewModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.identifier, for: indexPath) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        
        guard let photo = photoListViewModel?.photo(of: indexPath.item) else { return cell }
        
        DispatchQueue.global().async {
            let url = URL(string: photo.urls.regular)!
            let data = try! Data(contentsOf: url)
            DispatchQueue.main.async {
                cell.authorNameLabel.text = "\(photo.user.name)"
                cell.photoImageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
    func photo(of index: Int) -> Photo? {
        photoListViewModel?.photo(of: index)
    }
}
