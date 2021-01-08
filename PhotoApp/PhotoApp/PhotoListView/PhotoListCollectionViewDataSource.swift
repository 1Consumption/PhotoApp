//
//  PhotoListCollectionViewDataSource.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/09.
//

import UIKit

final class PhotoListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var model: [Photo] = dummyPhotos
    
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
    
    func photo(of index: Int) -> Photo? {
        guard index < model.count else { return nil }
        return model[index]
    }
}
