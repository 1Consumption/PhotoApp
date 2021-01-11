//
//  PhotoCollectionViewDataSource.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

final class PhotoCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var photoListViewModel: PhotoListViewModel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoListViewModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.identifier, for: indexPath) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        
        guard let photo = photoListViewModel?.photo(of: indexPath.item) else { return cell }
        let photoViewModel = PhotoViewModel(photo: photo)

        cell.bind(photoViewModel)
        
        return cell
    }
    
    func photo(of index: Int) -> Photo? {
        photoListViewModel?.photo(of: index)
    }
}
