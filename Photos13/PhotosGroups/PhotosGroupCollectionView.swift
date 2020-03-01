//
//  PhotosGroupCollectionView.swift
//  Fotos13
//
//  Created by Gary on 6/9/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos



let PhotosGroupCellReuseIdentifier = "PhotosGroupCollectionViewCell"

final class PhotosGroupCollectionViewController: UICollectionViewController, Storyboarded {
    
    weak var coordinator: AppCoordinator?
    private var previousPreheatRect: CGRect = CGRect.zero
    private var assetGridSize = CGSize.zero
    private var flowLayout: UICollectionViewFlowLayout!
    private let imageManager = PHImageManager()
    var assets = [PHAsset]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = backgroundColor
        
        self.collectionView!.register(PhotosGroupCollectionViewCell.self, forCellWithReuseIdentifier: PhotosGroupCellReuseIdentifier)
        self.flowLayout = UICollectionViewFlowLayout()
        self.collectionView!.collectionViewLayout = self.flowLayout
        self.collectionView!.backgroundColor = backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var cols: CGFloat = 4
        let width = self.collectionView!.frame.width
        if width > 480 {
            cols = 5
        }
        let itemSpacing: CGFloat = 5
        let size = (width - ((cols - 1) * itemSpacing) - 10) / cols
        
        self.assetGridSize = CGSize(width: size, height: size)
        self.flowLayout.itemSize = self.assetGridSize
        self.flowLayout.sectionInset = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
        self.flowLayout.minimumInteritemSpacing = itemSpacing
        self.flowLayout.minimumLineSpacing = itemSpacing
    }
    
}


// MARK: - UICollectionViewDataSource
extension PhotosGroupCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
    
}


// MARK: - UICollectionViewDelegate
extension PhotosGroupCollectionViewController  {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosGroupCellReuseIdentifier, for: indexPath as IndexPath) as! PhotosGroupCollectionViewCell
        
        let asset = self.assets[indexPath.row]
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        self.imageManager.requestImage(for: asset, targetSize: self.assetGridSize, contentMode: .aspectFit, options: options) {
            (image: UIImage?, info: [AnyHashable : Any]?) -> Void in
            
            cell.setImage(image: image)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.didSelectCameraRollPhoto(photoIndex: indexPath.row, assets: self.assets)
    }
}
