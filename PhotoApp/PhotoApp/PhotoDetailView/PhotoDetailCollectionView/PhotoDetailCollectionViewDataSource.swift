//
//  PhotoDetailCollectionViewDataSource.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/11.
//

import UIKit

final class PhotoDetailCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var photoList: PhotoList?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailCollectionViewCell.identifier, for: indexPath) as? PhotoDetailCollectionViewCell else { return UICollectionViewCell() }
        
        guard let photo = photoList?.photo(of: indexPath.item) else { return cell }
        let photoViewModel = PhotoViewModel(photo: photo)

        cell.bind(photoViewModel)
        
        return cell
    }
}
