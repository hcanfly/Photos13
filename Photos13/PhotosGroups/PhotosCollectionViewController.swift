//
//  PhotosCollectionViewController
//  Fhotos13
//
//  Created by Gary on 6/9/19.
//  Copyright © 2019 Gary. All rights reserved.
//
//  Note: the PHCachingImageManager code is based on Apple's SamplePhotosApp example.
//  https://developer.apple.com/library/ios/samplecode/UsingPhotosFramework/Listings/SamplePhotosApp_AAPLAssetGridViewController_m.html


import UIKit
import Photos



let PhotosCellReuseIdentifier = "PhotosCollectionViewCell"

final class PhotosCollectionViewController: RootViewController, UICollectionViewDelegateFlowLayout, Storyboarded {

    private var cachingImageManager: PHCachingImageManager?
    private var previousPreheatRect = CGRect.zero
    private var assetGridThumbnailSize = CGSize.zero
    private var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewId = .photos
        self.view.backgroundColor = backgroundColor
        self.collectionView.backgroundColor = backgroundColor
        
        self.collectionView!.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCellReuseIdentifier)
        self.flowLayout = UICollectionViewFlowLayout()
        self.collectionView!.collectionViewLayout = self.flowLayout
        self.collectionView!.backgroundColor = backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.cachingImageManager = PHCachingImageManager()
        self.resetCachedAssets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.collectionView!.frame.width
        let size = width / 5 - 20
        
        self.assetGridThumbnailSize = CGSize(width: size, height: size)
        self.flowLayout.itemSize = self.assetGridThumbnailSize
        self.flowLayout.minimumInteritemSpacing = 2
        self.flowLayout.minimumLineSpacing = 4
    }
    
    override func viewDidAppear(_ animated: Bool) {
       self.updateCachedAssets()
    }

}


// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Model.sharedInstance.assetCollection!.count
    }
    
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCellReuseIdentifier, for: indexPath as IndexPath) as! PhotosCollectionViewCell
        
        if let asset = Model.sharedInstance.assetCollection?[indexPath.item] {
            cell.assetIdentifier = asset.localIdentifier
            
            let size = self.assetGridThumbnailSize.width
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            self.cachingImageManager!.requestImage(for: asset, targetSize: CGSize(width: size, height: size), contentMode: PHImageContentMode.aspectFill, options: options) {
                (image: UIImage?, info: [AnyHashable : Any]?) -> Void in
                
                if cell.assetIdentifier == asset.localIdentifier {
                    cell.setImage(image: image)
                    cell.setMediaType(mediaType: asset.mediaType)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.didSelectCameraRollPhoto(photoIndex: indexPath.row, assets: nil)
    }
}


// MARK: - Asset Caching
extension PhotosCollectionViewController {
    
    private func resetCachedAssets() {
        self.cachingImageManager!.stopCachingImagesForAllAssets()
        self.previousPreheatRect = CGRect.zero
    }
    
    private func updateCachedAssets() {
        let isViewVisible = self.isViewLoaded && self.view.window != nil
        guard isViewVisible else {
            return
        }
        
        // The preheat window is twice the height of the visible rect.
        var preheatRect = self.collectionView!.bounds
        preheatRect = preheatRect.insetBy( dx: 0.0, dy: -0.5 * preheatRect.height)
        
        /*
         Check if the collection view is showing an area that is significantly
         different to the last preheated area.
         */
        let delta = abs(preheatRect.midY - self.previousPreheatRect.midY)
        if delta > (self.collectionView!.bounds.height / 3.0) {
            
            // Compute the assets to start caching and to stop caching.
            var addedIndexPaths = [NSIndexPath]()
            var removedIndexPaths = [NSIndexPath]()
            
            self.computeDifferenceBetweenRect(oldRect: self.previousPreheatRect, andRect: preheatRect, removedHandler: {
                removedRect -> Void in
                
                if let indexPaths = self.collectionView!.aapl_indexPathsForElementsInRect(rect: removedRect) {
                    removedIndexPaths += indexPaths
                }
            }, addedHandler: {
                addedRect -> Void in
                
                if let indexPaths = self.collectionView!.aapl_indexPathsForElementsInRect(rect: addedRect) {
                    addedIndexPaths += indexPaths
                }
            })
            
            // Update the assets the PHCachingImageManager is caching.
            if let assetsToStartCaching = self.assetsAtIndexPaths(indexPaths: addedIndexPaths) {
                self.cachingImageManager!.startCachingImages(for: assetsToStartCaching, targetSize: self.assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil)
            }
            
            if let assetsToStopCaching = self.assetsAtIndexPaths(indexPaths: removedIndexPaths) {
                self.cachingImageManager!.stopCachingImages(for: assetsToStopCaching, targetSize: self.assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil)
            }
            
            // Store the preheat rect to compare against in the future.
            self.previousPreheatRect = preheatRect
        }
    }
    
    private func computeDifferenceBetweenRect(oldRect: CGRect, andRect newRect:(CGRect), removedHandler: (CGRect) -> Void, addedHandler: (CGRect) -> Void) {
        if newRect.intersects(oldRect) {
            let oldMaxY = oldRect.maxY
            let oldMinY = oldRect.minY
            let newMaxY = newRect.maxY
            let newMinY = newRect.minY
            
            if newMaxY > oldMaxY {
                let rectToAdd = CGRect(x: newRect.origin.x, y: oldMaxY, width: newRect.size.width, height: (newMaxY - oldMaxY))
                addedHandler(rectToAdd)
            }
            
            if oldMinY > newMinY {
                let rectToAdd = CGRect(x: newRect.origin.x, y: newMinY, width: newRect.size.width, height: (oldMinY - newMinY))
                addedHandler(rectToAdd)
            }
            
            if newMaxY < oldMaxY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: newMaxY, width: newRect.size.width, height: (oldMaxY - newMaxY))
                removedHandler(rectToRemove)
            }
            
            if oldMinY < newMinY {
                let rectToRemove = CGRect(x: newRect.origin.x, y: oldMinY, width: newRect.size.width, height: (newMinY - oldMinY))
                removedHandler(rectToRemove)
            }
        } else {
            addedHandler(newRect)
            removedHandler(oldRect)
        }
    }
    
    private func assetsAtIndexPaths(indexPaths: [NSIndexPath]) -> [PHAsset]? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        var assets = [PHAsset]()
        assets.reserveCapacity(indexPaths.count)
        
        for indexPath in indexPaths {
            if indexPath.item == 0 {
                continue
            }
            
            let index = indexPath.item - 1
            
            if index < Model.sharedInstance.assetCollection!.count {
                if let asset = Model.sharedInstance.assetCollection?[index] {
                    assets.append(asset)
                }
            }
        }
        
        return assets
    }
    
}

extension UICollectionView {
    
    fileprivate func aapl_indexPathsForElementsInRect(rect: CGRect) -> [NSIndexPath]? {
        let allLayoutAttributes = self.collectionViewLayout.layoutAttributesForElements(in: rect)
        guard allLayoutAttributes!.count > 0 else {
            return nil
        }
        
        var indexPaths = [NSIndexPath]()
        indexPaths.reserveCapacity(allLayoutAttributes!.count)
        
        for layoutAttributes in allLayoutAttributes! {
            let indexPath = layoutAttributes.indexPath
            indexPaths.append(indexPath as NSIndexPath)
        }
        return indexPaths
    }
}


