//
//  PhotoListViewController.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/07.
//

import UIKit

final class PhotoListViewController: UIViewController {

    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoListCollectionView.dataSource = self
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoListCollectionViewCell.identifier, for: indexPath) as? PhotoListCollectionViewCell else { return UICollectionViewCell() }
        let number = Int.random(in: 1...8)
        cell.photoImageView.image = UIImage(named: "sample\(number)")
        cell.authorNameLabel.text = "Author \(number)"
        return cell
    }
}
