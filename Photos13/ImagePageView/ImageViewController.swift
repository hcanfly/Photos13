//
//  ImageViewController.swift
//  Fotos5
//
//  Created by Gary on 6/5/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit
import Photos

// syntactic sugar - no strings in #selector
private extension Selector {
    static let scrollViewDoubleTapped = #selector(ImageViewController.scrollViewDoubleTapped(_:))
}


final class ImageViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var asset: PHAsset?
    var assetIndex = 0
    let imageManager = PHImageManager()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.bounds = self.view.bounds
        self.scrollView.frame = self.scrollView.bounds
        self.imageView.frame = self.scrollView.bounds
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        self.scrollView.backgroundColor = backgroundColor
        self.scrollView.delegate = self
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: .scrollViewDoubleTapped)
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delegate = self
        self.scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        self.showImage()
    }
    
    private func showImage() {
        
        var asset: PHAsset
        if self.asset != nil {
            asset = self.asset!
        } else {
            asset = Model.sharedInstance.assetCollection![assetIndex]
        }
                
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: self.imageView.bounds.width * 2.0,height: self.imageView.bounds.height * 2.0), contentMode: .aspectFit, options: options) {
            (image: UIImage?, info: [AnyHashable : Any]?) -> Void in
            
            self.imageView.image = image
            self.setZoomAndScale()
       }
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        self.scrollView.bounds = self.view.bounds
        self.scrollView.frame = self.view.bounds
        self.imageView.frame = self.scrollView.bounds

        self.setZoomAndScale()
    }
    
    private func setZoomAndScale() {
        guard self.imageView.image != nil else { return }
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0

    }
    
    private func centerScrollViewContents() {
        
        let imageViewSize = self.imageView.frame.size
        let scrollViewSize = self.scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        self.scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    
    //MARK: - gesture recognizer
    @objc func scrollViewDoubleTapped(_ recognizer: UITapGestureRecognizer) {

        if self.scrollView.zoomScale == 1 {
            self.scrollView.zoom(to: zoomRectForScale(self.scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            self.scrollView.setZoomScale(1, animated: true)
        }
        
    }
    
    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        
        let newCenter = self.scrollView.convert(center, from: imageView)
        
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    //MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
    
}
